Clear-Host
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "FaceSnatch FB ID Extractor - PowerShell Edition" -ForegroundColor Green
Write-Host "Created by Yousef Elhalafawy. All rights reserved." -ForegroundColor Gray
Write-Host "=====================================================" -ForegroundColor Cyan

Write-Host "`nINSTRUCTIONS:"
Write-Host "1. Open the Facebook profile in your browser." -ForegroundColor Yellow
Write-Host "2. Right-click anywhere and choose 'View Page Source'." -ForegroundColor Yellow
Write-Host "3. Copy all the code and paste it into a .txt file." -ForegroundColor Yellow
Write-Host "4. Provide the full path to that .txt file when prompted." -ForegroundColor Yellow
Write-Host "`nThe script will extract and display the Facebook user ID(s).`n" -ForegroundColor Yellow

$filePath = Read-Host -Prompt "Enter the path to the view-source .txt file"

if (Test-Path $filePath -PathType Leaf) {
    Write-Host "`nReading file..." -ForegroundColor Cyan

    $data = Get-Content -Path $filePath -Raw
    $pattern = '"userID":"\d+'
    $matches = $data | Select-String -Pattern $pattern -AllMatches | ForEach-Object { $_.Matches.Value }
    $uniqueIDs = $matches | ForEach-Object { $_ -replace '"userID":"', '' } | Sort-Object -Unique

    if ($uniqueIDs.Count -gt 0) {
        Write-Host "`nFound $($uniqueIDs.Count) unique Facebook ID(s):`n" -ForegroundColor Green
        foreach ($id in $uniqueIDs) {
            Write-Host "ID: $id" -ForegroundColor Yellow
            Write-Host ""
	        Write-Host "Link: https://facebook.com/profile.php?id=$id" -ForegroundColor Yellow
        }

        $saveChoice = Read-Host -Prompt "`nDo you want to save these IDs to a file? (y/n)"
        if ($saveChoice -eq 'y') {
            $outputPath = Read-Host -Prompt "Enter output filename (e.g., ids.txt)"
            $uniqueIDs | Out-File -Encoding UTF8 $outputPath
            Write-Host "IDs saved to $outputPath" -ForegroundColor Cyan
        }
    } else {
        Write-Host "`nNo Facebook IDs found in the file." -ForegroundColor DarkYellow
    }
} else {
    Write-Host "`nFile not found or invalid path: $filePath" -ForegroundColor Red
}
