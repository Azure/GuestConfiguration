# Validate PS Version
$PSVersionTable

Write-Verbose "Re-run tests to verify signing process" -Verbose
../build.ps1 -tasks test

Write-Verbose "Run pack command" -Verbose
../build.ps1 -tasks package_module_nupkg

Write-Verbose "Move package into out directory" -Verbose
$RootPath = [io.Path]::GetFullPath("$PSScriptRoot/..")
# Get pipeline output directory
$outputDir = "$RootPath\..\out"
Write-Verbose "[OutputDir=$($outputDir)] ..." -Verbose
# $ev2_zip_filepath = "$outputDir\ServiceGroupRoot\$($extension_info.ExtensionInfo.PipelineConfig.ExtensionZipFileName)"

# Get built output directory
$packageOutput = Join-Path -Path $RootPath -ChildPath 'output'
Write-Verbose "[Build Output =$packageOutput] ..." -Verbose

# Move everything
Copy-Item -Path $packageOutput -Destination $outputDir -Recurse -Verbose
