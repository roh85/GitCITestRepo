if($args.Length -lt 1) {
    Write-Host "Configuration paramater should be set. Aborting script";
    return;
}

$CONFIGURATION = $args[0];

$NUNIT_EXE = Get-ChildItem "packages\NUnit.Runners.**\tools\nunit-console.exe"

$SEARCH_PATTERN = $NULL
$TESTS_ASSEMBLIES = $NULL

if(!(Test-Path $NUNIT_EXE)){
	throw("nunit-console.exe not found. Aborting tests")
}

If(Test-Path ".build"){
    $SEARCH_PATTERN = ".build\**.Tests.dll"
}
else{
    $SEARCH_PATTERN = "*.Tests\bin\$CONFIGURATION\*.Tests.dll"
}

if($SEARCH_PATTERN -ne $NULL){
    $TESTS_ASSEMBLIES = Get-ChildItem $SEARCH_PATTERN
}

if($TESTS_ASSEMBLIES -ne $NULL){
    ForEach($TEST in $TESTS_ASSEMBLIES){
        Invoke-Expression "$NUNIT_EXE /framework:net-4.0 /result:testresults.xml $TEST"
    }
}
