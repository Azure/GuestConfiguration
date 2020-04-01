# Change Log for GuestConfiguration module

## v1.20.0

- Support for custom Policy categories
- Re-implements FilesToInclude parameter for New-GCPackage for adding arbitrary files to content artifact
- Return error when attempting to protect package using invalid certificate
- Ensures shell script to install Inspec has Linux line endings
- Include PowerShell modules when they are required for DSC modules in packages
- More target file copy when creating custom packages
- Remove DataBricks from policy IF statements

## v1.19.3

- Bug fix for New-GuestConfigurationPolicy not generating correct Linux audit IF
- Bug fix for New-GuestConfigurationPackage to only copy native resources if needed
- Bug fix for Test-GuestConfigurationPackage error when only one resource

## v1.19.2

- Bug fix for Test-GuestConfigurationPackage
- Added agent versioning

## v1.19.1

- Bug fix for type error in subcmdlet
- moved build scripts to 'tools' folder
- Added basic project md files
- Added Azure DevOps build script

## v1.19.0

- Bug fix for new-guestconfigurationpolicy
