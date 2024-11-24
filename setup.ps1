# Define repository URL and file paths
$repoUrl = "https://github.com/07Snowman/Fs25ModsV2.git"
$repoFolder = "Fs25ModsV2"
$documentsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Documents", "My Games", "FarmingSimulator2025", "Mods")
$modsFolder = $documentsPath

Write-Host "[INFO] Starting script execution..."

# Step 1: Clone the repository
Write-Host "[INFO] Cloning repository..."
git clone $repoUrl $repoFolder
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to clone repository."
    exit $LASTEXITCODE
}
Write-Host "[INFO] Clone complete: $repoFolder"
# Define repository URL and file paths
$repoUrl = "https://github.com/07Snowman/Fs25ModsV2.git"
$repoFolder = "Fs25ModsV2"
$documentsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Documents", "My Games", "FarmingSimulator2025", "Mods")
$modsFolder = $documentsPath

Write-Host "[INFO] Starting script execution..."

# Step 1: Clone the repository
Write-Host "[INFO] Cloning repository..."
git clone $repoUrl $repoFolder
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to clone repository."
    exit $LASTEXITCODE
}
Write-Host "[INFO] Clone complete: $repoFolder"

# Step 2: Run git lfs pull
Write-Host "[INFO] Running git lfs pull..."
Set-Location -Path $repoFolder
git lfs pull
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to run git lfs pull."
    exit $LASTEXITCODE
}
Set-Location -Path ..

# Step 3: Extract ZIP files from repository folder to mods folder
function Extract-ZipFiles($sourceFolder, $destinationFolder) {
    if (!(Test-Path $sourceFolder)) {
        Write-Host "[ERROR] Source folder does not exist: $sourceFolder"
        return
    }

    if (!(Test-Path $destinationFolder)) {
        New-Item -Path $destinationFolder -ItemType Directory
        Write-Host "[INFO] Created destination folder: $destinationFolder"
    }

    Get-ChildItem -Path $sourceFolder -Recurse -Filter *.zip | ForEach-Object {
        $zipPath = $_.FullName
        $destinationPath = $destinationFolder

        if (!(Test-Path $destinationPath) -or (Get-Item $zipPath).LastWriteTime -gt (Get-Item $destinationPath).LastWriteTime) {
            Expand-Archive -Path $zipPath -DestinationPath $destinationPath -Force
            Write-Host "[INFO] Extracted: $zipPath -> $destinationPath"
        } else {
            Write-Host "[INFO] Skipped (already exists and is up-to-date): $destinationPath"
        }
    }
}

Write-Host "[INFO] Extracting ZIP files from $repoFolder to $modsFolder..."
Extract-ZipFiles -sourceFolder $repoFolder -destinationFolder $modsFolder
Write-Host "[INFO] ZIP files extracted successfully."

# Step 4: Notify completion
Write-Host "[INFO] Setup completed successfully!"
# Step 2: Run git lfs pull
Write-Host "[INFO] Running git lfs pull..."
Set-Location -Path $repoFolder
git lfs pull
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to run git lfs pull."
    exit $LASTEXITCODE
}
Set-Location -Path ..

# Step 3: Move ZIP files from repository folder to mods folder
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

Write-Host "[INFO] Moving ZIP files from $repoFolder to $modsFolder..."
Move-ZipFiles -sourceFolder $repoFolder -destinationFolder $modsFolder
Write-Host "[INFO] ZIP files moved successfully."

# Step 4: Notify completion
Write-Host "[INFO] Setup completed successfully!"