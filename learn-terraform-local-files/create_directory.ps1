# Check if the folder exists
if (Test-Path "./files") {
Write-Host "Folder does not exist. Creating..."
New-Item -Path "./" -Name "files" -ItemType Directory
Write-Host "Folder created successfully."
} else {
Write-Host "Folder already exists."
}