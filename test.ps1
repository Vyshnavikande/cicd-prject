Write-Host "Running automated test..."

if (Test-Path "cicd-prject.html") {
    Write-Host "Test Passed: cicd-prject.html file exists."
    exit 0
} else {
    Write-Host "Test Failed: cicd-prject.html file does not exist."
    exit 1
}