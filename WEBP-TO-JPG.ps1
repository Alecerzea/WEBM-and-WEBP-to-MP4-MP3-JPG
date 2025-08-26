# Check if ffmpeg is installed
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Host "[!] ffmpeg is not installed. Installing with winget..."
    winget install -e --id Gyan.FFmpeg
    if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
        Write-Host "[✗] Failed to install ffmpeg. Aborting."
        exit 1
    } else {
        Write-Host "[✓] ffmpeg installed successfully."
    }
}

# Get all .webp files in the current directory
$webpFiles = Get-ChildItem -Path . -Filter *.webp
if ($webpFiles.Count -eq 0) {
    Write-Host "No .webp files found in the current directory."
    exit
}

# Convert each file
foreach ($file in $webpFiles) {
    $jpgPath = [System.IO.Path]::ChangeExtension($file.FullName, ".jpg")
    Write-Host "[+] Converting $($file.Name) to $(Split-Path $jpgPath -Leaf)..."
    ffmpeg -loglevel error -i "$($file.FullName)" "$jpgPath"
    if (Test-Path $jpgPath) {
        Remove-Item "$($file.FullName)" -Force
        Write-Host "[✓] Converted and removed $($file.Name)"
    } else {
        Write-Host "[!] Failed to convert $($file.Name)"
    }
}
Write-Host "`n[✓] All .webp files processed."
