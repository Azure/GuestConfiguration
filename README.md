# Guest Configuration

![GuestConfig](./GuestConfigXS.png)

The Guest Configuration PowerShell module provides commands that automate
publishing custom content for Azure Policy to audit settings inside Azure virtual machines
and Arc connected machines.

There are three tasks that this module automates:

- Create the content package (.zip) from an existing DSC configuration (.mof)
- Functional validation of the content package
  - Contains required files
  - Runs the Audit against the local machine using the agent binaries used in Azure
- Publish the package to Azure blob storage
- Create the JSON files for the Azure Policy definitions (auditifnotexists, deployifnotexists, initiative)
- Publish the Azure Policy definitions to the currently selected subscription

Please leave comments, feature requests, and bug reports in the issues tab for
this module.

## Branches

### master

[![Build Status](https://dev.azure.com/guestconfiguration/guestconfigurationmodule/_apis/build/status/PowerShell.GuestConfiguration%20(Public)?branchName=master)](https://dev.azure.com/guestconfiguration/guestconfigurationmodule/_build/latest?definitionId=7&branchName=master)

This is the branch containing the latest release.
No contributions should be made directly to this branch.
Branch protection is set to require approval from atleast one reviewer.
A merge to this branch will trigger a new private build where,
if all tests pass, a release workflow will automatically
request human approval for publishing to the PowerShell Gallery.

### dev

[![Build Status](https://dev.azure.com/guestconfiguration/guestconfigurationmodule/_apis/build/status/PowerShell.GuestConfiguration%20(Public)?branchName=master)](https://dev.azure.com/guestconfiguration/guestconfigurationmodule/_build/latest?definitionId=7&branchName=dev)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).
A Pull Request should usually be pending from dev to master
with a clear title that stages the next release of the module.
The pull request should request atleast two reviewers and be tagged 'Release'.
Any new commits will automatically require new approval,
even if the PR had been previously approved.

## Installation

The agent binaries are added to the module when it is published to the PowerShell Gallery.
The module will not be functional if it is installed by cloning the GitHub repo.

To install from the PowerShell gallery using PowerShellGet
run the following command:

    Install-Module -Name GuestConfiguration -Repository PSGallery

## Requirements

The minimum PowerShell version is PowerShell 6.2.
Tests are performed using the latest preview of PowerShell.

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
