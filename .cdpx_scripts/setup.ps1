# Validate PS Version
$PSVersionTable

# Run build command, resolve ependencies (This step needs internet)
../build.ps1 -Tasks build -ResolveDependency

# Set up environment
Import-Module GuestConfiguration -Force

# Enable experimental feature
Get-ExperimentalFeature
Enable-ExperimentalFeature -Name GuestConfiguration.SetScenario
Enable-ExperimentalFeature -Name GuestConfiguration.Pester

exit 0
