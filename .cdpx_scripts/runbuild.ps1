# Validate PS Version
$PSVersionTable

# Set up environment
# Set up environment
$env:PSModulePath = "C:\source\output\" + ';' + $env:PSModulePath
Get-Module GuestConfiguration -ListAvailable
Import-Module GuestConfiguration -Force

# Enable experimental feature
Get-ExperimentalFeature

# Run Tests
../build.ps1 -Tasks test
