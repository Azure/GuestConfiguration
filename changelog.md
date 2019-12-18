# Change Log for GuestConfiguration module

## v1.19.1

- Bug fix for type error in subcmdlet
- moved build scripts to 'tools' folder
- Added basic project md files
- Added Azure DevOps build script

## v1.19.0

- Fix Linux line endings in InSpec profiles
- Resolve bug in custom categories
- Catch signing error output when certificate is invalid
- update IF for AINE and DINE to support hybrid and Windows custom images

## v1.18.0

- seperated module and tests from base repo
- added support for MacOS; except for test and protect cmdlets
- added support for publishing definitions to a management group
- added support for custom categories
- correct issue where schema.mof file could be detected as policy name
- correct issue where importing latest version of helper module is not forced
- Switched audit policy to AuditIfNotExis
- Added basic project md files
- Added Azure DevOps build script
- Catch error if signing cert does not meet requirements
