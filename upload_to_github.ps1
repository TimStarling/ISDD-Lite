$ErrorActionPreference = "Stop"

$repoUrl = "https://github.com/TimStarling/Industrial-Surface-Defect-Detector.git"
$branchName = "main"
$commitMessage = "Initial open source release"

Write-Host "Checking git availability..."
git --version | Out-Null

if (-not (Test-Path ".git")) {
    Write-Host "Initializing git repository..."
    git init
}

$hasRemote = $false
try {
    $existingRemote = git remote get-url origin 2>$null
    if ($LASTEXITCODE -eq 0 -and $existingRemote) {
        $hasRemote = $true
    }
} catch {
    $hasRemote = $false
}

if ($hasRemote) {
    Write-Host "Updating origin remote..."
    git remote set-url origin $repoUrl
} else {
    Write-Host "Adding origin remote..."
    git remote add origin $repoUrl
}

Write-Host "Staging files..."
git add .

$status = git status --porcelain
if ($status) {
    Write-Host "Creating commit..."
    git commit -m $commitMessage
} else {
    Write-Host "No local changes to commit."
}

Write-Host "Switching branch to $branchName..."
git branch -M $branchName

Write-Host "Pushing to GitHub..."
git push -u origin $branchName

Write-Host "Done."
