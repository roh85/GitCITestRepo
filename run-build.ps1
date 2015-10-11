$PREBUILD_SCRIPT = Join-Path $PSScriptRoot "prebuild.ps1"

Invoke-Expression $PREBUILD_SCRIPT

Import-Module $env:ChocolateyInstall\lib\psake\tools\psake.psm1

$BUILD_FOLDER = Join-Path -Path $PSScriptRoot -ChildPath ".build"

Invoke-Psake .\build.ps1 -properties @{
	"build_artifacts_dir"=$BUILD_FOLDER; 
	"configuration"="Release";
	"solution"="GitCITestRepo.sln"
}