<#
.SYNOPSIS
    Resets the CalCrony TEST stack: pull the newest :main images, drop the test Postgres + DataProtection volumes, bring it back up.

.DESCRIPTION
    Runs nightly from the scheduled task "CalCrony test-stack reset" and on demand. The API migrates the fresh database on
    boot and the test bot re-registers its slash commands to the test guild, so a reset always comes back usable.

    SAFETY: refuses to run against any compose file whose services are not the test-calcrony-* containers, and refuses
    outright if the file mentions the production container names. Production (Z:\docker\calcrony) is out of reach by
    construction.

.PARAMETER StackDir
    The test stack directory (docker-compose.yml + .env). Default Z:\docker\test-calcrony.

.PARAMETER SkipPull
    Reuse the local images (skip `compose pull`).
#>
[CmdletBinding()]
param(
    [string]$StackDir = 'Z:\docker\test-calcrony',
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
    foreach ($name in 'test-calcrony-db', 'test-calcrony-api', 'test-calcrony-bot', 'test-calcrony-web') {
        if ($composeText -notmatch "(?m)^\s*container_name:\s*$name\s*$") {
            throw "REFUSING: $composePath does not declare container '$name'. This script only resets the test stack."
        }
    }
    if ($composeText -match '(?m)^\s*container_name:\s*calcrony-(db|api|bot|web)\s*$') {
        throw "REFUSING: $composePath references the PRODUCTION calcrony-* containers. Aborting."
    }
    if ($composeText -notmatch '(?m)^name:\s*test-calcrony\s*$') {
        throw "REFUSING: $composePath is not the 'test-calcrony' compose project (down -v would drop the wrong volumes)."
    }
    Log "Safety check passed - target is the test stack."

    Push-Location $StackDir
    try {
        if (-not $SkipPull) {
            Log "Pulling the newest images..."
            docker compose pull; if ($LASTEXITCODE) { throw "compose pull failed." }
        }
        Log "Dropping the stack and its volumes..."
        docker compose down -v; if ($LASTEXITCODE) { throw "compose down failed." }
        Log "Bringing the stack up (API migrates on boot)..."
        docker compose up -d; if ($LASTEXITCODE) { throw "compose up failed." }

        Log "Waiting for the API on :5861 and the web on :5863..."
        $ready = $false
        for ($i = 0; $i -lt 48; $i++) {
            Start-Sleep -Seconds 5
            try {
                $api = Invoke-WebRequest -Uri 'http://localhost:5861/health/ready' -UseBasicParsing -TimeoutSec 5
                $web = Invoke-WebRequest -Uri 'http://localhost:5863/' -UseBasicParsing -TimeoutSec 5
                if ($api.StatusCode -eq 200 -and $web.StatusCode -eq 200) { $ready = $true; break }
            } catch { }
        }
        if (-not $ready) { throw "The test stack did not answer on :5861 / :5863 in time." }

        Log "RESET COMPLETE - fresh database, images at the configured tag."
    }
    finally {
        Pop-Location
    }
}
catch {
    Log "FAILED: $($_.Exception.Message)"
    exit 1
}
