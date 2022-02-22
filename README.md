# PowerShell module for Microsoft Azure Policy's guest configuration

![GuestConfig](./GuestConfigXS.png)

The `GuestConfiguration` PowerShell module provides commands
that assist authors in  creating, testing, and publishing
custom content for guest configureation to manage settings
inside Azure virtual machines and Arc-enabled servers.

Tasks that this module automates:

- Create the content package (.zip) from an existing DSC configuration (.mof)
- Test content package against the local machine
- Publish the package
- Create Azure Policy definitions
- Publish Azure Policy definitions

Please leave comments, feature requests, and bug reports in the issues tab for
this module.

## Branches

### master

[![Build Status](https://dev.azure.com/guestconfiguration/guestconfigurationmodule/_apis/build/status/PowerShell.GuestConfiguration%20(Public)?branchName=master)](https://dev.azure.com/guestconfiguration/guestconfigurationmodule/_build/latest?definitionId=7&branchName=master)

This is the branch containing the latest release.
No contributions should be made directly to this branch.
Branch protection is set to require approval from at least one reviewer.

## Installation

The agent binaries are added to the module
when it is published to the PowerShell Gallery.
The module will not be functional if it is installed by cloning the GitHub repo.

To install from the PowerShell gallery using PowerShellGet
run the following command:

    Install-Module -Name GuestConfiguration -Repository PSGallery

## Requirements

The minimum PowerShell version is
PowerShell 7.1.3 for Windows and
7.2 preview 6 for Linux.

## Changelog

A full list of changes in each version can be found in the
[change log](CHANGELOG.md)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Branch naming conventions
This repository uses git versioning to automatically calculate the newest version of the module. Branches that begin with "feature/" will increment the minor version, and those that begin with "fix" will increment the patch version. Please refer to the GitVersion.yml file for more details. 

## How to Build
Steps to build the repository for the first time:

To perform tasks with the GuestConfiguration module, navigate to the GuestConfiguration repository 

* To build the repository
  `./build.ps1 -tasks build`
* To run no operation
  `./build.ps1 -tasks noop`
* To install required modules 
  `./build.ps1 -tasks noop -RequiredModules`
* To run all tests
  `./build.ps1 -tasks test`
* To run a specific test
  `./build.ps1 -tasks test -PesterScript [Insert Path to Script]`
* To perform several tasks, you can use a comma delimeter for the task parameter
  `./build.ps1 -tasks test, build`

## Example of Initial Build
1. Install RequiredModules with `-RequiredModules` tag
  `./build.ps1 -tasks noop -RequiredModules`
1. Build 
  `./build.ps1 -tasks build`
1. Import Module
  `Import-Module GuestConfiguration -Force`
1. Run tests
  `./build.ps1 -tasks test`
1. Run specific test
  `./build.ps1 -tasks test -PesterScript ./Tests/Unit/Public/foo.tests.ps1`

## Common Error Messages

| Error Message         | Solution|
|-----------------------|----------------------------------------------------------------------|
| "Sampler does not exist..." | Make sure you are using pwsh7, not PowerShell 5 |
| Unable to find Path in Sampler/Invoke-Pester.psm1 | Make sure you only have one copy of Pester on your machine. `Get-Module Pester -ListAvailable` and delete excess copies.  |
|Test-GuestConfigurationPackage -Path ../AzureDockerBaseline.zip -Verbose Publish-DscConfiguration: Exception calling "PublishDscConfiguration" with "5" argument(s): "Value cannot be null. (Parameter 'path1')" | Ensure you are using pwsh-preview on a Linux machine | 
| Failed to initialize DSC Library. | Something could be wrong with the agent. Try deleting the agent on your machine in C:\ProgramData\GuestConfig\ and run `Install-GuestConfigurationAgent -Force -Verbose`|
|A second CIM class definition for 'MSFT_ChefInSpecResource' was found while processing the schema file| PowerShell has loaded a CIM class definition twice in one session. Ignorable. |

## Contents

| File/folder           | Description                                                          |
|-----------------------|----------------------------------------------------------------------|
| `source`              | All source files used to build the module.                           |
| `Tests`               | Pester tests for evaluating the current quality of the module.       |
| `.gitignore`          | Define what to ignore at commit time.                                |
| `Tools`               | Build scripts to test public PRs using Azure DevOps.                 |
| `CODE_OF_CONDUCT.md`  | Code of conduct for participating in this community collaboration.   |
| `LICENSE`             | The license for the sample.                                          |
| `README.md`           | This README file.                                                    |
| `SECURITY.md`         | How to report security issues.                                       |
