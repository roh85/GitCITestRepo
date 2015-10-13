$PREBUILD_SCRIPT = Join-Path $PSScriptRoot "prebuild.ps1"
$BUILD_SCRIPT = Join-Path $PSScriptRoot "default.ps1"

$SOLUTION_FILE = Join-Path $PSScriptRoot "GitCITestRepo.sln"

# Debug, Release
$BUILD_CONFIGURATION = "Release"

# Output directory that will contain all compiled binaries
$ARTIFACTS_DIR = Join-Path -Path $PSScriptRoot -ChildPath ".build"

# Execute prebuild script to install all prerequisites
Invoke-Expression $PREBUILD_SCRIPT

# Build script uses PSake so import the PSake module
Import-Module $env:ChocolateyInstall\lib\psake\tools\psake.psm1

# Execute PSake build tasks
Invoke-Psake $BUILD_SCRIPT -properties @{
	"build_artifacts_dir"=$ARTIFACTS_DIR; 
	"configuration"=$BUILD_CONFIGURATION;
	"solution"="$SOLUTION_FILE"
}