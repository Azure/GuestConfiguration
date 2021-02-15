# Change Log for GuestConfiguration module

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Pipeline and project structure updated to match DSC Community Projects.

## [3.1.3] - 2021-02-03

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
