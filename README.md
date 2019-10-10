# Guest Configuration

![GuestConfig](./GuestConfigXS.png)

The Guest Configuration PowerShell module provides commands that automate
publishing custom content for Azure Policy to audit settings inside virtual machines.

There are three tasks that this module automates:

- Creating the content package (.zip) from an existing DSC configuration (.mof)
- Functional validation of the content package
  - Contains required files
  - Runs the Audit against the local machine using the agent binaries used in Azure
- Create the JSON files for the Azure Policy definitions (auditifnotexists, deployifnotexists, initiative)
- Publish the Azure Policy definitions to the currently selected subscription

Please leave comments, feature requests, and bug reports in the issues tab for
this module.

## Branches

### master

[![Build Status](https://dev.azure.com/migreene-dev/GuestConfiguration/_apis/build/status/mgreenegit.GuestConfiguration?branchName=master)](https://dev.azure.com/migreene-dev/GuestConfiguration/_build/latest?definitionId=5&branchName=master)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build Status](https://dev.azure.com/migreene-dev/GuestConfiguration/_apis/build/status/mgreenegit.GuestConfiguration?branchName=dev)](https://dev.azure.com/migreene-dev/GuestConfiguration/_build/latest?definitionId=5&branchName=dev)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Installation

The agent binaries are added to the module when it is published to the PowerShell Gallery.
The module will not be functional if it is installed by cloning the GitHub repo.

To install from the PowerShell gallery using PowerShellGet (in PowerShell 5.0)
run the following command:

    Install-Module -Name GuestConfiguration -Repository PSGallery

## Requirements

The minimum PowerShell version is
PowerShell 5.1 or higher, which ships with Windows 10 Anniiversary Update and in Windows Server 2016 R2.

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
| `DscResources`        | Resources provided as built-in in all packages.                      |
| `helpers`             | PowerShell script modules containing helper functions.               |
| `Tests`               | Pester tests for custom resource modules.                            |
| `.gitignore`          | Define what to ignore at commit time.                                |
| `azure-pipelines.yml` | A build script for this project to automate publishing to PSGallery. |
| `CODE_OF_CONDUCT.md`  | Code of conduct for participating in this community collaboration.   |
| `LICENSE`             | The license for the sample.                                          |
| `README.md`           | This README file.                                                    |
| `SECURITY.md`         | How to report security issues.                                       |
