# Change Log for GuestConfiguration module

## v2.0.0

- Support for "AINE without DINE"
- Arc for Servers parameter

## v1.20.3

- Fix error when creating Linux policy, "RPName" variable no longer used

## v1.20.2

- Throw error if PSDesiredStateConfiguration resources are included

## v1.20.1

- Fix issue with filestoinclude not finding temp package folder

## v1.20.0

- Update API version for Managed Service Identity
- Support for custom Policy categories
- Adds support for additional Linux distributions
- Download location for InSpec requirements
- Support custom VM images
- Support Arc machines
- Re-implements FilesToInclude parameter for New-GCPackage for adding arbitrary files to content artifact
- Return error when attempting to protect package using invalid certificate
- Ensures shell script to install Inspec has Linux line endings
- Include PowerShell modules when they are required for DSC modules in packages
- More target file copy when creating custom packages
- Remove DataBricks from policy IF statements
- Support filtering policy for single tag name/value

## v1.19.4

- Fix issue with filestoinclude not finding temp package folder

## v1.20.0

- Update API version for Managed Service Identity
- Support for custom Policy categories
- Adds support for additional Linux distributions
- Download location for InSpec requirements
- Support custom VM images
- Support Arc machines
- Re-implements FilesToInclude parameter for New-GCPackage for adding arbitrary files to content artifact
- Return error when attempting to protect package using invalid certificate
- Ensures shell script to install Inspec has Linux line endings
- Include PowerShell modules when they are required for DSC modules in packages
- More target file copy when creating custom packages
- Remove DataBricks from policy IF statements
- Support filtering policy for single tag name/value

## v1.19.4

- Updated InSpec installation uri
- Bug fix for Test-GuestConfigurationPackage functionality on Ubuntu 16.04
- Bug fix for better config refreshing after InSpec profile updates

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
