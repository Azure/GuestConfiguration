# Change Log for GuestConfiguration module

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- More messaging in New-GuestConfigurationPolicy around the package version and type
- Added the SASExpirationInDays parameter to Publish-GuestConfigurationPackage so the customer can control the expiration time of their generated SAS token.
- Added examples and more help text to Protect-GuestConfigurationPackage and updated the tests
- Added the ContentVersion parameter to New-GuestConfigurationPolicy to validate the downloaded package version before putting it into the policy definition.

### Changed

- Module now works with PowerShell 5.1 on Windows
- New-GuestConfigurationPolicy will now throw when you are trying to create an Apply policy with an Audit-only package.
- Publish-GuestConfigurationPackage now authenticates via New-AzStorageContext
- Publish-GuestConfigurationPackage now requires the StorageContainerName parameter
- Changed the 'Version' parameter to 'PolicyVersion' for New-GuestConfigurationPolicy

### Fixed

- Test-GuestConfigurationPackage, Get-GuestConfigurationPackageComplianceStatus, and Start-GuestConfigurationPackageRemediation can now take relative paths to the package again

### Removed

- Publish-GuestConfigurationPolicy has been removed as it was just a wrapper for New-AzPolicyDefinition. Please use New-AzPolicyDefinition to publish your generated policy definition files instead.
- Removed Publish-GuestConfigurationPackage as it was just a wrapper for Az storage cmdlets. Please use Az cmdlets if you would like to upload your package to Az storage instead.
- Removed the ResourceGroupName parameter from Publish-GuestConfigurationPackage as it is no longer needed.
- Removed the internal submodule GuestConfigPath and other functions that weren't used anymore (no impact on functionality)
- Removed dependencies on Az cmdlets and PSDesiredStateConfiguraiton module

## [4.0.0-preview0005] - 2022-04-19

### Fixed

- Fixed the GC worker included in the module (for invoking packages)

## [4.0.0-preview0004] - 2022-04-18

### Added

- Lots of test updates. Added new tests with Script resource.

### Changed

- Refactored the New-GuestConfigurationPolicy cmdlet
  - Removed the GuestConfigPolicy "submodule"
  - Added policy definition templates for easier updates
  - Includes new multiple assignments naming format
  - Updated images
  - Stabilizing Set policies

### Fixed

- Fixed bug in Test-GuestConfigurationPackage/Get-GuestConfigurationPackageComplianceStatus in which the package path was not getting quoted causing a problem with spaces in the path.
- Fixed the FrequencyMinutes parameter of New-GuestConfigurationPackage

## [4.0.0-preview0003] - 2022-01-12

### Changed

- Update Test-GuestConfigurationPackage/Get-GuestConfigurationCompliance status to run completely within the module path instead of using Guest Configuration system paths that overlap with any Guest Configuration agent running on the system
- Completely remove any old package folders before re-creating/updating the package via New-GuestConfiguraitonPackage

## [4.0.0-preview0002] - 2021-11-24

### Changed

- New-GuestConfigurationPackage
  - Change to file type parameters instead of strings
  - Resolve all path parameters to full paths
  - Add Verbose messaging
  - Switch to built-in compression cmdlet (Compress-Archive)
- Clean Test-GuestConfigurationPackage tests and remove skip flag for bug on Linux

## [4.0.0-preview0001] - 2021-11-24

### Changed

- Rewrite of New-GuestConfigurationPackage
  - Remove extra folder level created under Path
  - Remove any existing working folder before updating package
  - Change Version parameter to a String
  - Change Type parameter to a String
  - Remove extra.metaconfig.json file. Properties are now consolidated in metaconfig.json instead.
  - Do not add GuestConfiguration module to new packages
  - Do not add native InSpec resource files to packages that are not using it
  - Validate module dependencies
  - Add nested module dependencies to package
  - Update tests

### Removed

- Remove experimental Pester resource

## [3.5.3]

### Removed

- Do not check PATCH version in semver format when determining PowerShell 7.2 release

## [3.5.2] - 2021-10-15

### Changed

- Resolved issue where PowerShell version prerelease label is sorted as string
rather than integer
- Update ReadMe

## [3.4.2] - 2021-08-09

### Added

- Code signing changes to builds

## [3.3.1] - 2021-07-30

### Added

- Added `Install-GuestConfigurationPackage`.
- Updated `New-GuestConfigurationPackage` to support PackageType.
- Updated `New-GuestConfigurationPolicy` to support AssignmentType (Audit, ApplyAndMonitor, ApplyAndCorrect) and creation of DeployIfNotExists.json
- Added `Get-GuestConfigurationPackageName`
- Added `Get-GuestConfigurationPackageNameFromZip`
- Updated `New-GuestConfigurationPolicy` to include guestconfig object in metadata for DINE policies. The included configurationParameter matches the pattern of AINEs.
- Added more tests to `New-GuestConfigurationPolicy.Tests` to cover metadata scenario.
- Added dependency on PSDesiredStateConfiguration. 

### Changed

- Pipeline and project structure updated to match DSC Community Projects.
- Fixed casing of default parameter in generated policy, which caused issues on manual import
- Changed how meta config are written to different files, and read from both
- Install PSDesiredStateConfiguration V3 onto Ubuntu machine
- Remove testing inspec on Linux machines, as we will no longer be supporting that scenario
- Fixed `New-GuestConfigurationPolicy` to create arrays for configurationParameter when no parameters are passed in
- No longer using -Package as a valid parameter for any commands
- Require policyId parameter for `New-GuestConfigurationPolicy`
- Removed ability to pass in package name for `Install-GuestConfigurationPackage`
 
## [3.2.0] - 2021-02-23

### Added

- Expiremental support for Pester as an audit language## [3.1.3] - 2021-02-03

### Changed

- 'FilesToInclude' parameter should copy contents to 'Modules' folder
- New-GuestConfigurationPackage cmdlet should copy ChefInspec resource from latest GuestConfiguration module
  
## [3.1.2] - 2021-01-26

### Changed

- Repair carriage return line ending in inspec install script

## [3.1.1-prerelease] - 2020-12-23

### Added

- Adds pipline input for New-GuestConfigurationPackage

## [3.1.0-prerelease] - 2020-12-23

### Added

- Add pipeline input support for Publish-GCPackage and New-GCPolicy

### Changed

- Publish-GCPackage returns object containing ContentURI property, in support of New-GCPolicy input from pipeline

## [3.0.0] - 2020-12-09

### Changed

- Deprecate the 'Category' parameter due to service changes for Guest Assignment automatic creation
- Catch the Test-GuestConfigurationPackage cmdlet when attempting to run on MacOS

## [2.2.0] - 2020-11-20

### Fixed

- Update to path for GC lib was not updated

## [2.1.0] - 2020-10-26

### Added

- New cmdlet publish-guestconfigurationpackage

## [2.0.0] - 2020-10-05

### Added

- Support for "AINE without DINE"
- Arc for Servers parameter

## [1.20.3-prerelease] - 2020-06-02

### Fixed

- Fix error when creating Linux policy, "RPName" variable no longer used

## [1.20.2-prerelease] - 2020-05-29

### Fixed

- Throw error if PSDesiredStateConfiguration resources are included

## [1.20.1-prerelease] - 2020-05-04

### Fixed

- Fix issue with filestoinclude not finding temp package folder

## [1.20.0-prerelease] - 2020-04-30

### Added

- Support for custom Policy categories
- Adds support for additional Linux distributions
- Support Arc machines
- Support custom VM images
- Support filtering policy for single tag name/value

### Changed

- Update API version for Managed Service Identity
- Download location for InSpec requirements
- Re-implements FilesToInclude parameter for New-GCPackage for adding arbitrary files to content artifact
- Return error when attempting to protect package using invalid certificate
- Ensures shell script to install Inspec has Linux line endings
- Include PowerShell modules when they are required for DSC modules in packages
- More target file copy when creating custom packages
- Remove DataBricks from policy IF statements

## [1.19.4] - 2020-04-23

### Fixed

- Fix issue with filestoinclude not finding temp package folder

## [1.19.3-prerelease] - 2020-03-30

### Fixed

- Bug fix for New-GuestConfigurationPolicy not generating correct Linux audit IF
- Bug fix for New-GuestConfigurationPackage to only copy native resources if needed
- Bug fix for Test-GuestConfigurationPackage error when only one resource

## [1.19.2-prerelease] - 2020-03-27

### Added

- Added agent versioning

### Fixed

- Bug fix for Test-GuestConfigurationPackage

## [1.19.1-prerelease] - 2020-03-04

### Added

- Added basic project md files
- Added Azure DevOps build script

### Fixed

- Bug fix for type error in subcmdlet

### Changed

- moved build scripts to 'tools' folder

## [1.19.0.0] - 2020-01-17

### Fixed

- Bug fix for new-guestconfigurationpolicy
