Write-Output "About to run build"
Write-Verbose "About to run build" -Verbose

$RootPath = [io.Path]::GetFullPath("$PSScriptRoot/..")

$srcRootPath = "$RootPath\src"
$ev2RootPath = "$srcRootPath\ev2"
$outputDir = "$RootPath\out"
$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$location = Join-Path $currentDir "\.."
$env:APPVEYOR_BUILD_FOLDER = $location
$destination = Join-Path $env:SystemDrive 'out'

../build.ps1 -Tasks noop -ResolveDependency
../build.ps1 -Tasks build
Write-Verbose "Exiting build script..." -Verbose
