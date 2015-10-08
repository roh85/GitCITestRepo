Import-Module $env:ChocolateyInstall\lib\psake\tools\psake.psm1

$build_folder = Join-Path -Path $PSScriptRoot -ChildPath ".build"

Invoke-Psake .\build.ps1 -properties @{
	"build_artifacts_dir"=$build_folder; 
	"configuration"="Release";
	"solution"="GitCITestRepo.sln"
}