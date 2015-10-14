$NUNIT_EXE = Get-ChildItem "packages\NUnit.Runners.**\tools\nunit-console.exe"

if(!(Test-Path $NUNIT_EXE)){
	throw("nunit-console.exe not found. Aborting tests")
}

$TESTS_ASSEMBLIES = Get-ChildItem ".build\**.Tests.dll"

if($TESTS_ASSEMBLIES -ne $NULL){
    ForEach($TEST in $TESTS_ASSEMBLIES){
        Invoke-Expression "$NUNIT_EXE /framework:net-4.0 /result:testresults.xml $TEST"
    }
}
