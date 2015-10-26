# This build assumes you have psake installed: https://github.com/psake/psake/
# You can install this on your Windows machine by using chocolatey: https://chocolatey.org/
#			"choco install psake"
#
# For easy use we will use parameter overrides when invoking psake to not overly complicate the build file
#
#  build_artifacts_dir 		- This folder is created if it is missing and contains output of the build
#  configuration			- The configuration used to build eg. Debug, Release
#  solution					- Name of the solution file
#

Properties {
	$build_artifacts_dir = $null
	$configuration = $null
	$solution = $null
	$project = $null
}

FormatTaskName (("-"*25) + "[{0}]" + ("-"*25))

Task Default -depends TestProperties, Build, InspectCode, Test, Pack

task TestProperties { 
	Assert ($build_artifacts_dir -ne $null) "build_artifacts_dir should not be null"
	Assert ($configuration -ne $null) "configuration should not be null"
	Assert ($solution -ne $null) "solution should not be null"
	Assert ($project -ne $null) "project should not be null"
}

Task Build -Depends Clean {
	Write-Host "Building GitCITestRepo.sln" -ForegroundColor Green
	Exec { msbuild $solution /t:Rebuild  /p:Configuration=Release /p:Platform="Any CPU" /v:q }  
}	

Task Clean {
	Write-Host "Cleaning GitCITestRepo.sln" -ForegroundColor Green
	
	Exec { msbuild $solution /t:Clean  /p:Configuration=$configuration /p:Platform="Any CPU" /v:q }

	# Define files and directories to delete
	$include = @("*.suo","*.user","*.cache","*.docstates","bin","obj","build", ".build", "testresults.xml", "inspectcodereport.xml")

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
	inspectcode /o="inspectcodereport.xml" $solution
	
Task InspectCodeParser -Depends InspectCode	
	Write-Host "Parsing InspectCode output" -ForegroundColor Green
	$PARSER = Join-Path $PSScriptRoot "resharper-clt-parser.ps1"
	Invoke-Expression "$PARSER inspectcodereport.xml"
	
}

Task Test -Depends Build {
	Write-Host "Running NUnit tests" -ForegroundColor Green
	$TEST_RUNNER = Join-Path $PSScriptRoot "runtests.ps1 $configuration"
	Invoke-Expression $TEST_RUNNER
}

Task Pack -Depends Build {
	Write-Host "Pack solution" -ForegroundColor Green
	7z a "$project.zip" .\$project\bin\$configuration\*.*
}