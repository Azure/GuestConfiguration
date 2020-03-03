@{

# Script module or binary module file associated with this manifest.
RootModule = 'GuestConfiguration.psm1'

# Version number of this module.
moduleVersion = '1.19.1'

# ID used to uniquely identify this module
GUID = '164465d5-6575-4e7f-b80b-680e4198354e'

# Author of this module
Author = 'Azure Guest Configuration'

# Company or vendor of this module
CompanyName = 'MicrosoftCorporation'

# Copyright statement for this module
Copyright = '(c) 2019 Microsoft Corporation. All rights reserved.'

# Description of the functionality provided by this module
Description = '[PREVIEW] The Guest Configuration module is an experimental tool to assist content authoring for Azure Guest Configuration. The cmdlets will help build and publish a content package, wich can then be used in cross-platform configuration management solutions.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('Az.Accounts','Az.Resources')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('New-GuestConfigurationPackage', 'Test-GuestConfigurationPackage', 'Protect-GuestConfigurationPackage', 'New-GuestConfigurationPolicy', 'Publish-GuestConfigurationPolicy')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
DscResourcesToExport = @( 'ChefInSpecResource' )

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'GuestConfiguration', 'Azure', 'DSC'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/PowerShell/GuestConfiguration/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/PowerShell/GuestConfiguration'

        # A URL to an icon representing this module.
        IconUri = 'https://github.com/PowerShell/GuestConfiguration/GuestConfigXS.png'

        # ReleaseNotes of this module
        ReleaseNotes = 'https://github.com/PowerShell/GuestConfiguration/changelog.md'

    } # End of PSData hashtable

} # End of PrivateData hashtable

}