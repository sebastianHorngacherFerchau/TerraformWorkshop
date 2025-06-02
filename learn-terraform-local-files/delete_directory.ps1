# Check if the folder exists
if (Test-Path "./files") {
Write-Host "Folder exists. Deleting..."
Remove-Item "./files" -Recurse -Force
Write-Host "Folder deleted successfully."
} else {
Write-Host "Folder does not exist."
}