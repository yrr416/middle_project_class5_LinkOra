$sourceBase = "C:\Users\ict-\.gemini\antigravity\brain"
$targetBase = "D:\dev\midProject\midproject\_ai_project_logs"

# Ensure target directory exists
if (-not (Test-Path $targetBase)) { New-Item -ItemType Directory -Path $targetBase }

# Official report filters
$officialFilters = @("implementation_plan.md", "task.md", "walkthrough.md")

# Get all .md files in the brain folder recursively
Get-ChildItem -Path $sourceBase -Filter "*.md" -Recurse | Where-Object { 
    $officialFilters -contains $_.Name 
} | ForEach-Object {
    # Extract date and ID for renaming
    $date = $_.LastWriteTime.ToString("yyyy-MM-dd")
    $idShort = $_.Directory.Name.Substring(0, 6)
    $newName = "${date}_${idShort}_$($_.Name)"
    $targetPath = Join-Path $targetBase $newName
    
    # Copy file, handle duplicates by adding index if needed
    if (-not (Test-Path $targetPath)) {
        Copy-Item $_.FullName -Destination $targetPath
        Write-Host "Migrated: $newName"
    } else {
        $count = 1
        while (Test-Path "$targetBase\${date}_${idShort}_${count}_$($_.Name)") {
            $count++
        }
        Copy-Item $_.FullName -Destination "$targetBase\${date}_${idShort}_${count}_$($_.Name)"
        Write-Host "Migrated (Conflict-Resolved): ${date}_${idShort}_${count}_$($_.Name)"
    }
}

# Create Archive Index
$indexContent = "# 🗂️ AI Project Archive Index`n"
$indexContent += "본 폴더는 프로젝트 시작부터 현재까지 생성된 모든 AI 공식 리포트(계획서, 할 일 목록, 워크스루)의 보관소입니다.`n`n"
$indexContent += "| 날짜 | 세션 ID | 문서 종류 | 파일 링크 |`n"
$indexContent += "| :--- | :--- | :--- | :--- |`n"

Get-ChildItem -Path $targetBase -Filter "*.md" | Sort-Object Name | ForEach-Object {
    if ($_.Name -ne "00_Archive_Index.md") {
        $parts = $_.BaseName.Split('_')
        if ($parts.Length -ge 3) {
            $date = $parts[0]
            $id = $parts[1]
            $type = $parts[2..($parts.Length-1)] -join "_"
            $indexContent += "| $date | $id | $type | [$($_.Name)](file:///$($_.FullName -replace '\\', '/')) |`n"
        }
    }
}

Set-Content -Path (Join-Path $targetBase "00_Archive_Index.md") -Value $indexContent -Encoding UTF8
Write-Host "Created: 00_Archive_Index.md"
