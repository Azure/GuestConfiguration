@{
    # Version number of this module.
    moduleVersion        = '8.2.0'

    # ID used to uniquely identify this module
    GUID                 = 'B5004952-489E-43EA-999C-F16A25355B89'

    # Author of this module
    Author               = 'DSC Community'

    # Company or vendor of this module
    CompanyName          = 'DSC Community'

    # Copyright statement for this module
    Copyright            = 'Copyright the DSC Community contributors. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'DSC resources for configuration of a Windows computer. These DSC resources allow you to perform computer management tasks, such as renaming the computer, joining a domain and scheduling tasks as well as configuring items such as virtual memory, event logs, time zones and power settings.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '4.0'

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion           = '4.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = @()

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport      = @()

    # Variables to export from this module
    VariablesToExport    = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport      = @()

    # DSC resources to export from this module
    DscResourcesToExport = @(
        'Computer'
        'OfflineDomainJoin'
        'PendingReboot'
        'PowerPlan'
        'PowerShellExecutionPolicy'
        'RemoteDesktopAdmin'
        'ScheduledTask'
        'SmbServerConfiguration'
        'SmbShare'
        'SystemLocale'
        'TimeZone'
        'VirtualMemory'
        'WindowsEventLog'
        'WindowsCapability'
        'IEEnhancedSecurityConfiguration'
        'UserAccountControl'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{
            # Set to a prerelease string value if the release should be a prerelease.
            Prerelease   = ''

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('DesiredStateConfiguration', 'DSC', 'DSCResource')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/dsccommunity/ComputerManagementDsc/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/dsccommunity/ComputerManagementDsc'

            # A URL to an icon representing this module.
            IconUri      = 'https://dsccommunity.org/images/DSC_Logo_300p.png'

            # ReleaseNotes of this module
            ReleaseNotes = '## [8.2.0] - 2020-05-05

### Changed

- Change Azure DevOps Pipeline definition to include `source/*` - Fixes [Issue #324](https://github.com/dsccommunity/ComputerManagementDsc/issues/324).
- Updated pipeline to use `latest` version of `ModuleBuilder` - Fixes [Issue #324](https://github.com/dsccommunity/ComputerManagementDsc/issues/324).
- Merge `HISTORIC_CHANGELOG.md` into `CHANGELOG.md` - Fixes [Issue #325](https://github.com/dsccommunity/ComputerManagementDsc/issues/325).
- ScheduledTask:
  - Fix ServiceAccount behavior on Windows Server 2016 - Fixes [Issue #323](https://github.com/dsccommunity/ComputerManagementDsc/issues/323).
  - Fixed problems in integration test configuration naming.
  - Changed `ScheduledTaskExecuteAsGroupAdd` and `ScheduledTaskExecuteAsGroupMod`
    to use a group name that does not include a domain name `BUILTIN\`.
  - Added known issues to the documentation for describing `ExecuteAsCredential`
    behavior - Fixes [Issue #294](https://github.com/dsccommunity/ComputerManagementDsc/issues/294).
- PendingReboot:
  - Changed integration tests to clear pending file rename reboot flag before
    executing tests and restoring when complete.

'
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}



