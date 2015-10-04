Import-Module $env:ChocolateyInstall\lib\psake\tools\psake.psm1

Invoke-Psake .\build.ps1 -properties @{
	"build_artifacts_dir"=".build"; 
	"configuration"="Release";
	"solution"="GitCITestRepo.sln"
}