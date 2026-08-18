<#
.SYNOPSIS
    Resets the FairShare TEST stack: pull the newest :main images, drop the test database volume, bring it back up.

.DESCRIPTION
    Runs nightly from the scheduled task "FairShare test-stack reset" and on demand. The API reseeds the admin
    account from the stack .env on first boot, so a reset always comes back sign-in-able.

    SAFETY: refuses to run against any compose file whose services are not the fairshare-test-* containers, and
    refuses outright if the file mentions the production container names. Production (Z:\docker\fairshare) is out
    of reach by construction.

.PARAMETER StackDir
    The test stack directory (docker-compose.yml + .env). Default Z:\docker\fairshare-test.

.PARAMETER SkipPull
    Reuse the local images (skip `compose pull`).
#>
[CmdletBinding()]
param(
    [string]$StackDir = 'Z:\docker\fairshare-test',
    [switch]$SkipPull
)

$ErrorActionPreference = 'Stop'

$composePath = Join-Path $StackDir 'docker-compose.yml'
$envPath = Join-Path $StackDir '.env'
$script:logPath = $null

function Log([string]$msg) {
    $line = "{0:u}  {1}" -f (Get-Date), $msg
    if ($script:logPath) {
        try { $line | Tee-Object -FilePath $script:logPath -Append; return } catch { }
    }
    Write-Host $line
}

try {
    $logDir = Join-Path $StackDir 'logs'
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }
    $script:logPath = Join-Path $logDir ("reset-{0:yyyyMMdd-HHmmss}.log" -f (Get-Date))

    if (-not (Test-Path $composePath)) { throw "No docker-compose.yml in $StackDir." }
    if (-not (Test-Path $envPath)) { throw "No .env in $StackDir." }

    # --- SAFETY INTERLOCK: this must be the TEST stack, never production ---
    $composeText = Get-Content $composePath -Raw
    if ($composeText -notmatch '(?m)^\s*container_name:\s*fairshare-test-api\s*$' -or
        $composeText -notmatch '(?m)^\s*container_name:\s*fairshare-test-web\s*$') {
        throw "REFUSING: $composePath does not declare the fairshare-test-api / fairshare-test-web containers. This script only resets the test stack."
    }
    if ($composeText -match '(?m)^\s*container_name:\s*fairshare-(api|web)\s*$') {
        throw "REFUSING: $composePath references the PRODUCTION containers fairshare-api / fairshare-web. Aborting."
    }
    if ($composeText -notmatch '(?m)^name:\s*fairshare-test\s*$') {
        throw "REFUSING: $composePath is not the 'fairshare-test' compose project (down -v would drop the wrong volume)."
    }
    Log "Safety check passed - target is the test stack."

    Push-Location $StackDir
    try {
        if (-not $SkipPull) {
            Log "Pulling the newest :main images..."
            docker compose pull; if ($LASTEXITCODE) { throw "compose pull failed." }
        }
        Log "Dropping the stack and its volume..."
        docker compose down -v; if ($LASTEXITCODE) { throw "compose down failed." }
        Log "Bringing the stack up..."
        docker compose up -d; if ($LASTEXITCODE) { throw "compose up failed." }

        Log "Waiting for the API on :5869 and the web on :5868..."
        $ready = $false
        for ($i = 0; $i -lt 36; $i++) {
            Start-Sleep -Seconds 5
            try {
                $api = Invoke-WebRequest -Uri 'http://localhost:5869/healthz' -UseBasicParsing -TimeoutSec 5
                $web = Invoke-WebRequest -Uri 'http://localhost:5868/' -UseBasicParsing -TimeoutSec 5
                if ($api.StatusCode -eq 200 -and $web.StatusCode -eq 200) { $ready = $true; break }
            } catch { }
        }
        if (-not $ready) { throw "The test stack did not answer on :5869 / :5868 in time." }

        Log "RESET COMPLETE - fresh database, admin reseeded from .env, images at :main."
    }
    finally {
        Pop-Location
    }
}
catch {
    Log "FAILED: $($_.Exception.Message)"
    exit 1
}
