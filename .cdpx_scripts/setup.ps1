# Validate PS Version
$PSVersionTable

# Run build command, resolve ependencies (This step needs internet)
../build.ps1 -Tasks build -ResolveDependency

# Set up environment
Get-ChildItem "C:\source\output\GuestConfiguration\3.2.0\bin\"
$env:PSModulePath = "C:\source\output\" + ';' + $env:PSModulePath
Get-Module GuestConfiguration -ListAvailable
Import-Module GuestConfiguration -Force

# Enable experimental features
Get-ExperimentalFeature
Enable-ExperimentalFeature -Name GuestConfiguration.SetScenario
Enable-ExperimentalFeature -Name GuestConfiguration.Pester
Enable-ExperimentalFeature -Name PSDesiredStateConfiguration.InvokeDscResource

exit 0
