# Change Log for GuestConfiguration module

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [4.1.0] - 2022-06-14

### Changed

- New-GuestConfigurationPackage will no longer create the unzipped package folder under your provided Path or working directory. The package will instead be created under the module's temporary directory and only the .zip file will be generated at the provided destination Path or working directory. This fixes the issue that the the source .mof file was getting deleted when it was under a subpath that needs to be removed to create the package.

## [4.0.0] - 2022-06-13

### Added

- The cmdlets Get-GuestConfigurationPackageComplianceStatus and Start-GuestConfigurationPackageRemediation will now throw an error when the Modules folder in the package does not contain any subfolders.

### Changed

- Moved the module out of preview
- In New-GuestConfigurationPackage, added more messaging to the warning message when a mof contains the GuestConfiguration module.

## [4.0.0-preview0011] - 2022-06-09

### Fixed

- The cmdlet New-GuestConfigurationPackage will never include the GuestConfiguration module in the Modules folder of the new package (this makes the package too big). A warning will be written instead.
- The cmdlets New-GuestConfigurationPackage and Protect-GuestConfigurationPackage now use a different compression method which allows empty folders to be zipped into the package (previously empty folders were disappearing when the package was zipped).

## [4.0.0-preview0010] - 2022-06-07

### Fixed

- The cmdlets Get-GuestConfigurationPackageComplianceStatus and Start-GuestConfigurationPackageRemediation will now only search for nested module dependencies in the package Modules folder

## [4.0.0-preview0009] - 2022-05-27

### Changed

- For New-GuestConfigurationPolicy, the IncludeArcMachines policy parameter type has been switched back to a string so that old policies can still be updated

## [4.0.0-preview0008] - 2022-05-24

### Fixed 

- Start-GuestConfigurationPackageComplianceStatus and Start-GuestConfigurationPackageRemediation will run again on packages that are missing the metaconfig file. Added tests for this as well.
- Fixed some typos in the New-GuestConfigurationPolicy help comments

## [4.0.0-preview0007] - 2022-05-19

### Changed

- On New-GuestConfigurationPolicy, PolicyId and PolicyVersion are now mandatory parameters
- New-GuestConfigurationPolicy now outputs the definition file to the current working directory by default
- Start-GuestConfigurationPackageRemediation will now throw an error if you try to apply/remediate an Audit-only package
- On New-GuestConfigurationPackage, the FilesToInclude parameter is now a string array that can take in multiple file/folder paths to include under the Modules path in the package

### Fixed

- Fixed another bug when you try to create a package under the same path that your source .mof file is at
- Fixed the cmdlet help
- Fixed the policy definition unicode single quotes when using New-GuestConfigurationPolicy with PS 5.1

### Removed

- Removed Test-GuestConfigurationPackage and its tests as this cmdlet was an exact copy of Get-GuestConfigurationPackageComplianceStatus

## [4.0.0-preview0006] - 2022-05-10

### Added

- Added more messaging in New-GuestConfigurationPolicy around the package version and type
- Added examples and more help text to Protect-GuestConfigurationPackage and updated the tests
- Added the 'ContentVersion' parameter to New-GuestConfigurationPolicy to validate the downloaded package version before putting it into the policy definition

### Changed

- Module now works with PowerShell 5.1 on Windows. Also confirmed that the module works with PS 7.1.3 on Windows and PS 7.2.3 (latest) on both Windows and Linux.
- New-GuestConfigurationPolicy will now throw when you are trying to create an Apply policy with an Audit-only package
- Changed the 'Version' parameter to 'PolicyVersion' for New-GuestConfigurationPolicy
- Test-GuestConfigurationPackage, Get-GuestConfigurationPackageComplianceStatus, and Start-GuestConfigurationPackageRemediation will now validate that parameters passed in have the correct properties and are all strings

### Fixed

- Test-GuestConfigurationPackage, Get-GuestConfigurationPackageComplianceStatus, and Start-GuestConfigurationPackageRemediation can now take relative paths to the package again
- Fixed a bug when you try to create a package under the same path that your source .mof file is at

### Removed

- Removed dependencies on the Az and PSDesiredStateConfiguration modules
- Removed Publish-GuestConfigurationPolicy as it was just a wrapper for New-AzPolicyDefinition. Please use New-AzPolicyDefinition to publish your generated policy definition files instead.
- Removed Publish-GuestConfigurationPackage as it was just a wrapper for Az storage cmdlets. Please use Az cmdlets if you would like to upload your package to Az storage instead.
- Removed the internal submodule GuestConfigPath and other functions that weren't used anymore (no impact on functionality)

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

- Added 'Install-GuestConfigurationPackage'.
- Updated 'New-GuestConfigurationPackage' to support PackageType.
- Updated 'New-GuestConfigurationPolicy' to support AssignmentType (Audit, ApplyAndMonitor, ApplyAndCorrect) and creation of DeployIfNotExists.json
- Added 'Get-GuestConfigurationPackageName'
- Added 'Get-GuestConfigurationPackageNameFromZip'
- Updated 'New-GuestConfigurationPolicy' to include guestconfig object in metadata for DINE policies. The included configurationParameter matches the pattern of AINEs.
- Added more tests to 'New-GuestConfigurationPolicy.Tests' to cover metadata scenario.
- Added dependency on PSDesiredStateConfiguration. 

### Changed

- Pipeline and project structure updated to match DSC Community Projects.
- Fixed casing of default parameter in generated policy, which caused issues on manual import
- Changed how meta config are written to different files, and read from both
- Install PSDesiredStateConfiguration V3 onto Ubuntu machine
- Remove testing inspec on Linux machines, as we will no longer be supporting that scenario
- Fixed 'New-GuestConfigurationPolicy' to create arrays for configurationParameter when no parameters are passed in
- No longer using -Package as a valid parameter for any commands
- Require policyId parameter for 'New-GuestConfigurationPolicy'
- Removed ability to pass in package name for 'Install-GuestConfigurationPackage'
 
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
