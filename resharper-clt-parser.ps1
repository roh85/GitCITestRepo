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
$messages = @()

foreach($i in $issues){
	$issueType = $îssueTypes | ? { $_.Id -eq $i.TypeId }
	$messages += New-Object PSObject -Property @{
		File = $i.File
		Message = $i.Message
		Severity = $issueType.Severity
		Line = $i.Line
	}
}

foreach($msg in $messages){
		Write-Host $msg
		if($msg.Severity -eq "SUGGESTION" -or $msg.Severity -eq "HINT") { Add-AppveyorMessage -Message $msg.Message -Category "Information" -Details "$msg.File $msg.Line" }
		elseif($msg.Severity -eq "WARNING") { Add-AppveyorMessage -Message $msg.Message -Category "Warning" -Details "$msg.File $msg.Line" }
		elseif($msg.Severity -eq "ERROR") { Add-AppveyorMessage -Message $msg.Message -Category "Error" -Details "$msg.File $msg.Line" }		
}