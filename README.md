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
