# --- Configuration ---
# This script is designed to backup your Docker configuration and data to OneDrive using 7-Zip. It also handles stopping and starting your Docker stacks in a specific order to ensure a smooth backup process. Make sure to update the paths and stack names to match your setup before running the script.
$SourceDir = "Z:\your\source\to\docker"
$BackupDest = "B:\your\backup\location\Docker Backup"
$Timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$ZipFileName = "Docker_Backup_$Timestamp.zip"
$FullDestPath = Join-Path -Path $BackupDest -ChildPath $ZipFileName

# --- Path to 7-Zip ---
# Make sure to update this path to where you have 7-Zip installed. The script uses 7-Zip to create a zip archive of your Docker configuration and data. You can download 7-Zip from https://www.7-zip.org/ if you don't have it installed.
$7ZipPath = "C:\your\path\to\7-Zip\7z.exe"

# --- Startup Priority Order ---
# Define the order in which stacks should be stopped and started. Stopping is done in reverse order to ensure dependencies are handled correctly.
$StackOrder = @("arrs", "media-server", "utilities-stack", "exposed-services")

# --- 1. Stop All Stacks (Reverse Order) ---
# Stopping stacks in reverse order ensures that dependent services are stopped after the services they depend on, preventing potential issues during shutdown.
Write-Host "Stopping Docker stacks..." -ForegroundColor Yellow
$ReverseOrder = $StackOrder[($StackOrder.Count-1)..0]
foreach ($stack in $ReverseOrder) {
    $path = Join-Path $SourceDir $stack
    if (Test-Path "$path\docker-compose.yml") {
        Write-Host "Downing $stack..."
        Set-Location $path
        docker-compose down
    }
}

# --- 2. Pull Latest Images ---
# Pulling the latest images ensures that your stacks are up-to-date with the newest versions of the containers. This is especially important if you have any stacks that rely on external images that may have been updated since the last time you ran them.
Write-Host "Pulling latest images for all stacks..." -ForegroundColor Cyan
foreach ($stack in $StackOrder) {
    $path = Join-Path $SourceDir $stack
    if (Test-Path "$path\docker-compose.yml") {
        Write-Host "Checking for updates in $stack..."
        Set-Location $path
        docker-compose pull
    }
}

# --- 3. Run Backup with 7-Zip ---
# The backup process uses 7-Zip to create a zip archive of your Docker configuration and data. The -ssw option ensures that shared files are included in the backup, while the -snl option preserves symbolic links, which can help avoid issues with certain applications (like NPM) that rely on symlinks. The -mx5 option sets the compression level to a good balance between speed and compression ratio.
Write-Host "Archiving to OneDrive (38GB+ total)..." -ForegroundColor Cyan
try {
    # -ssw: backup shared files, -snl: store symbolic links (fixes NPM cert issues)
    & $7ZipPath a -tzip "$FullDestPath" "$SourceDir\arrs" "$SourceDir\media-server" "$SourceDir\utilities-stack" "$SourceDir\exposed-services" "$SourceDir\scripts" "-xr!*.sock" "-xr!*.pipe" "-mx5" "-ssw" "-snl"
    Write-Host "Backup successful: $ZipFileName" -ForegroundColor Green
}
catch {
    Write-Error "7-Zip failed: $_"
}

# --- 4. Start Stacks in Priority Order ---
# Starting stacks in the defined order ensures that any dependencies are started in the correct sequence, which can help prevent issues with services that rely on others being available.
Write-Host "Starting Docker stacks in priority order..." -ForegroundColor Yellow
foreach ($stack in $StackOrder) {
    $path = Join-Path $SourceDir $stack
    if (Test-Path "$path\docker-compose.yml") {
        Write-Host "Upping $stack..."
        Set-Location $path
        # 'up -d' will automatically use the newly pulled images
        docker-compose up -d
        Start-Sleep -Seconds 5 
    }
}

# --- 5. Cleanup Old Backups (Keep last 3 days) ---
# This cleanup step ensures that you don't accumulate too many old backups over time, which can take up valuable storage space. The script looks for zip files in the backup destination and removes any that were created more than 3 days ago. You can adjust the retention period by changing the number of days in the AddDays(-3) method.
Write-Host "Cleaning up old backups (3-day retention)..." -ForegroundColor Gray
Get-ChildItem -Path $BackupDest -Filter "*.zip" | 
    Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-3) } | 
    Remove-Item -Force

Set-Location $SourceDir
Write-Host "All processes complete. Docker is updated and online." -ForegroundColor Green