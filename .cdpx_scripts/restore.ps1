# Validate PS Version
$PSVersionTable

# Set up environment
Import-Module GuestConfiguration -Force

# Enable experimental feature
Get-ExperimentalFeature

# Run Tests
../build.ps1 -Tasks test
