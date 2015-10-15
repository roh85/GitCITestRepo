if($args.Length -lt 1) {
    Write-Host "Configuration paramater should be set. Aborting script";
    return;
}

$CONFIGURATION = $args[0];

$NUNIT_EXE = Get-ChildItem ".\packages\NUnit.Runners.**\tools\nunit-console.exe"
$OPENCOVER_EXE = Get-ChildItem ".\packages\OpenCover.4.6.166\tools\OpenCover.Console.exe"

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
    $TESTS_ASSEMBLIES = (Get-ChildItem $SEARCH_PATTERN) -join ' '
}

if($TESTS_ASSEMBLIES -ne $NULL){
        #Invoke-Expression "$NUNIT_EXE /framework:net-4.0 /result:testresults.xml $TEST"
		#Invoke-Expression $OPENCOVER_EXE -register:user -target:$NUNIT_EXE -targetargs:$TESTS_ASSEMBLIES -noshadow -appveyor "-filter:+[GitCITestRepo*]*" -excludebyattribute:"*.ExcludeFromCodeCoverage*" -hideskipped:All -output:".\coverage.xml"
		.\packages\OpenCover.4.6.166\tools\OpenCover.Console.exe -register:user "-filter:+[GitCITestRepo]* -[*Test]* -[*Program]*" -excludebyattribute:*.ExcludeFromCodeCoverage* -hideskipped:All "-target:$NUNIT_EXE" "-targetargs:/framework:net-4.0 /result:testresults.xml /noshadow $TESTS_ASSEMBLIES" -output:".\coverage.xml"
		.\packages\ReportGenerator.2.3.2.0\tools\ReportGenerator.exe "-reports:coverage.xml" "-targetdir:.\.coverage"
}
