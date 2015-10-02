Write-Host "*******************************************************************";
Write-Host "***********             Resharper-CLT parser      ****************";
Write-Host "*******************************************************************";
if($args.Length -lt 1) {
    Write-Host "Not enough arguments passed, skipping script";
    return;
}
$file = $args[0];

$xml = [xml](get-content $file)
$îssueTypes = $xml.SelectNodes("/Report/IssueTypes/IssueType")
$issues = $xml.SelectNodes("/Report/Issues/Project/Issue")
$merged = @()

foreach($i in $issues){
	$issueType = $îssueTypes | ? { $_.Id -eq $i.TypeId }
	$merged += New-Object PSObject -Property @{
		File = $i.File
		Message = $i.Message
		Severity = $issueType.Severity
		Line = $i.Line
	}
}

foreach($el in $merged){
		Write-Host $el
		Add-AppveyorMessage -Message $el.Message -Category $el.Severity -Details [string]::format("{2} {3}", $el.File, $el.Line)
}