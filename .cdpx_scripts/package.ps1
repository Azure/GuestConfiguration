Write-Verbose "Re-run tests to verify signing process" -Verbose
../build.ps1 -tasks test

Write-Verbose "About to run pack command" -Verbose
../build.ps1 -tasks package_module_nupkg
