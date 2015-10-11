$TOOLS_DIR = Join-Path $PSScriptRoot "tools"

$NUGET_URL = "https://nuget.org/nuget.exe"
$NUGET_EXE = Join-Path $TOOLS_DIR "nuget.exe"

$CHOCOLATEY_URL = "https://chocolatey.org/install.ps1"
$CHOCOLATEY_EXE = "choco"



# Install Chocolatey package manager
if(!(Get-Command "choco" -errorAction SilentlyContinue)) {
	Write-Host "Installing Chocolatey package manager" -ForegroundColor Green
	(iex ((new-object net.webclient).DownloadString($CHOCOLATEY_URL)))>$null 2>&1
}

# Install Nuget package manager
# Try download NuGet.exe if do not exist.
if (!(Test-Path $NUGET_EXE)) {
	Write-Host "Installing nuget package manager" -ForegroundColor Green

	Write-Host "Creating Tools directory" -ForegroundColor Green
	if (Test-Path $TOOLS_DIR)
	{
		rd $TOOLS_DIR -rec -force | out-null
	}

	mkdir $TOOLS_DIR | out-null

	Invoke-WebRequest $NUGET_URL -OutFile $NUGET_EXE
	Set-Alias nuget $NUGET_EXE -Scope Global -Verbose
}

# Make sure NuGet exists where we expect it.
if (!(Test-Path $NUGET_EXE)) {
    Throw "Could not find NuGet.exe"
}

# Restore tools from NuGet?
Write-Host "Restoring nuget packages" -ForegroundColor Green
Invoke-Expression "$NUGET_EXE restore"