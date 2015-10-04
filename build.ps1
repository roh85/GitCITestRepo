# This build assumes you have psake installed: https://github.com/psake/psake/
# You can install this on your Windows machine by using chocolatey: https://chocolatey.org/
#			"choco install psake"
#
# For easy use we will use parameter overrides when invoking psake to not overly complicate the build file
#
#  build_artifacts_dir 		- This folder is created if it is missing and contains output of the build
#  configuration			- The configuration used to build eg. Debug, Release
#

Properties {
	$build_artifacts_dir = $null
	$configuration = $null
	$solution = $null
}

FormatTaskName (("-"*25) + "[{0}]" + ("-"*25))

Task Default -depends TestProperties, Build, InspectCode

task TestProperties { 
	Assert ($build_artifacts_dir -ne $null) "build_artifacts_dir should not be null"
	Assert ($configuration -ne $null) "configuration should not be null"
	Assert ($solution -ne $null) "solution should not be null"
}

Task Build -Depends Clean {
	Write-Host "Building GitCITestRepo.sln" -ForegroundColor Green
	Exec { msbuild $solution /p:OutDir=$build_artifacts_dir /t:Rebuild  /p:Configuration=Release /p:Platform="Any CPU" /v:q }
	#Exec { &("C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe") $solution /p:Platform="Any CPU" /v:q }   
}	

Task Clean {
	Write-Host "Cleaning GitCITestRepo.sln" -ForegroundColor Green
	
	Exec { msbuild $solution /p:OutDir=$build_artifacts_dir /t:Clean  /p:Configuration=$configuration /p:Platform="Any CPU" /v:q }

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

	Write-Host "Creating BuildArtifacts directory" -ForegroundColor Green
	if (Test-Path $build_artifacts_dir)
	{
		rd $build_artifacts_dir -rec -force | out-null
	}

	mkdir $build_artifacts_dir | out-null
}

Task InspectCode -Depends Build {
	Write-Host "Running InspectCode" -ForegroundColor Green
	inspectcode /o="inspectcodereport.xml" $solution
	
Task InspectCodeParser -Depends InspectCode	
	Write-Host "Parsing InspectCode output" -ForegroundColor Green
	.\resharper-clt-parser.ps1 "inspectcodereport.xml"	
}

Task Test -PreCondition { return Test-CommandExists("xunit") } {
   # Exec { xunit ".\build\*.Tests.dll" } TODO
}