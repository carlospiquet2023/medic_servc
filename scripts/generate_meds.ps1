Param(
    [int]$count = 3000,
    [string]$outPath = "$PSScriptRoot\..\medicacoes\medicamentos_full.json"
)

$baseTypes = @('analgésico','antibiótico','antifúngico','antiviral','antihipertensivo','antidiabético','psicotrópico','anti-inflamatório','antialérgico','gastroprotetor')
$units = @(50,100,125,150,200,250,300,400,500)

$list = @()
for ($i=1; $i -le $count; $i++) {
    $name = "Medicação $i"
    $id = "med_$i"
    $type = $baseTypes[$i % $baseTypes.Count]
    $unitMg = $units[$i % $units.Count]
    $defaultDurationDays = if ($i % 2 -eq 0) {7} else {14}
    $obj = @{ id = $id; name = $name; type = $type; unitMg = $unitMg; defaultDurationDays = $defaultDurationDays }

    if ($i % 3 -eq 0) {
        $obj.adultDoseMgKg = 10 + ($i % 6)
        $obj.maxPerDoseMg = [math]::Max(200, $obj.adultDoseMgKg * 70)
        $obj.maxPerDayMg = $obj.maxPerDoseMg * 3
    } elseif ($i % 5 -eq 0) {
        $obj.standardDoseMg = $unitMg * [math]::Max(1, [math]::Round((50 + ($i % 100)) / $unitMg))
    }

    $list += (New-Object PSObject -Property $obj)
}

# Ensure output directory exists
$outDir = Split-Path -Path $outPath -Parent
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

# Export to JSON
$list | ConvertTo-Json -Depth 5 | Out-File -FilePath $outPath -Encoding UTF8
Write-Output "Gerado $count medicações em: $outPath"
