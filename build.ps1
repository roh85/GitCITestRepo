Import-Module C:\ProgramData\chocolatey\lib\psake\tools\psake.psm1

FormatTaskName (("-"*25) + "[{0}]" + ("-"*25))

Task Default -depends Build, InspectCode

Task Build -Depends Clean {
	Write-Host "Building GitCITestRepo.sln" -ForegroundColor Green
	Exec { msbuild "GitCITestRepo.sln" /t:Rebuild  /p:Configuration=Release /p:Platform="Any CPU" /v:q }
	#Exec { &("C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe") "GitCITestRepo.sln" /p:Platform="Any CPU" /v:q }   
}	

Task Clean {
	Write-Host "Cleaning GitCITestRepo.sln" -ForegroundColor Green
	
	# Define files and directories to delete
	$include = @("*.suo","*.user","*.cache","*.docstates","bin","obj","build")

	# Define files and directories to exclude
	$exclude = @()

	$items = Get-ChildItem $path -recurse -force -include $include -exclude $exclude

	if ($items) {
		foreach ($item in $items) {
			Remove-Item $item.FullName -Force -Recurse -ErrorAction SilentlyContinue
			Write-Host "Deleted" $item.FullName
		}
	}	
}

Task InspectCode -Depends Build {
	Write-Host "Running InspectCode" -ForegroundColor Green
	inspectcode /o="inspectcodereport.xml" GitCITestRepo.sln
	
Task InspectCodeParser -Depends InspectCode	
	Write-Host "Parsing InspectCode output" -ForegroundColor Green
	.\resharper-clt-parser.ps1 "inspectcodereport.xml"	
}