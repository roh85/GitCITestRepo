$NUGET_URL = "https://nuget.org/nuget.exe"
$NUGET_EXE = "Nuget.exe"

$CHOCOLATEY_URL = "https://chocolatey.org/install.ps1"
$CHOCOLATEY_EXE = "choco"

# Install Chocolatey package manager
if(!(Get-Command "choco" -errorAction SilentlyContinue)) {
	Write-Host "Installing Chocolatey package manager"
	(iex ((new-object net.webclient).DownloadString($CHOCOLATEY_URL)))>$null 2>&1
}

# Make sure NuGet exists where we expect it.
if (!(Test-Path $CHOCOLATEY_EXE)) {
    Throw "Could not find choco"
}

# Install Nuget package manager
# Try download NuGet.exe if do not exist.
if (!(Test-Path $NUGET_EXE)) {
	Write-Host "Installing Nuget package manager"
	Invoke-WebRequest $NUGET_URL -OutFile $NUGET_EXE
	Set-Alias nuget $NUGET_EXE -Scope Global -Verbose
}

# Make sure NuGet exists where we expect it.
if (!(Test-Path $NUGET_EXE)) {
    Throw "Could not find NuGet.exe"
}