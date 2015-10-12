Write-Host "*******************************************************************";
Write-Host "***********             Pre-build script           ****************";
Write-Host "*******************************************************************";

$NUGET_DIR = Join-Path $PSScriptRoot ".nuget"

$NUGET_URL = "https://nuget.org/nuget.exe"
$NUGET_EXE = Join-Path $NUGET_DIR "nuget.exe"

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
	if (Test-Path $NUGET_DIR)
	{
		rd $NUGET_DIR -rec -force | out-null
	}

	mkdir $NUGET_DIR | out-null

	Invoke-WebRequest $NUGET_URL -OutFile $NUGET_EXE
	Set-Alias nuget $NUGET_EXE -Scope Global -Verbose
}

# Make sure NuGet exists where we expect it.
if (!(Test-Path $NUGET_EXE)) {
    Throw "Could not find nuget.exe"
}

# Restore tools from NuGet?
Write-Host "Restoring nuget packages" -ForegroundColor Green
Invoke-Expression "$NUGET_EXE restore"

# Install needed choco packages
Write-Host "Installing choco packages" -ForegroundColor Green
Invoke-Expression "choco install psake -y"
Invoke-Expression "choco install resharper-clt -Pre -y"