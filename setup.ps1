# Define repository download URL and file paths
$repoUrl = "https://github.com/07Snowman/Fs25Mods/archive/refs/heads/main.zip"
$zipFile = "repo.zip"
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")
$documentsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Documents", "My Games", "FarmingSimulator2025", "Mods")
$extractPath = $desktopPath
$modsFolder = $documentsPath
$repoDownloadFolder = $documentsPath


Write-Host "[INFO] Starting script execution..."

# Step 1: Download repository as a ZIP file
Write-Host "[INFO] Downloading repository..."
Invoke-RestMethod -Uri $repoUrl -OutFile $zipFile
Write-Host "[INFO] Download complete: $zipFile"

# Step 2: Extract the ZIP file
Write-Host "[INFO] Extracting repository..."
Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force
Write-Host "[INFO] Extraction complete: $extractPath"

# Step 3: Move extracted folder to the desired location
$extractedFolder = [System.IO.Path]::Combine($extractPath, "Fs25Mods-main")
if (Test-Path $extractedFolder) {
    Move-Item -Path $extractedFolder -Destination $repoDownloadFolder -Force
    Write-Host "[INFO] Moved extracted folder to: $repoDownloadFolder"
} else {
    Write-Host "[ERROR] Extraction failed or folder not found."
}

# Step 4: Clean up the ZIP file
Remove-Item $zipFile
Write-Host "[INFO] Cleaned up temporary files."

# Step 5: Move ZIP files from repository folder to mods folder
function Move-ZipFiles($sourceFolder, $destinationFolder) {
    if (!(Test-Path $sourceFolder)) {
        Write-Host "[ERROR] Source folder does not exist: $sourceFolder"
        return
    }

    if (!(Test-Path $destinationFolder)) {
        New-Item -Path $destinationFolder -ItemType Directory
        Write-Host "[INFO] Created destination folder: $destinationFolder"
    }

    Get-ChildItem -Path $sourceFolder -Recurse -Filter *.zip | ForEach-Object {
        $sourcePath = $_.FullName
        $destinationPath = [System.IO.Path]::Combine($destinationFolder, $_.Name)

        if (!(Test-Path $destinationPath) -or (Get-Item $sourcePath).LastWriteTime -gt (Get-Item $destinationPath).LastWriteTime) {
            Move-Item -Path $sourcePath -Destination $destinationPath -Force
            Write-Host "[INFO] Moved: $sourcePath -> $destinationPath"
        } else {
            Write-Host "[INFO] Skipped (already exists and is up-to-date): $destinationPath"
        }
    }
}

Write-Host "[INFO] Moving ZIP files from $repoDownloadFolder to $modsFolder..."
Move-ZipFiles -sourceFolder $repoDownloadFolder -destinationFolder $modsFolder
Write-Host "[INFO] ZIP files moved successfully."



# Step 7: Notify completion
Write-Host "[INFO] Setup completed successfully!"