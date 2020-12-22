@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'PesterResource.psm1'
    
    # Version number of this module.
    moduleVersion = '1.0.0'
    
    # ID used to uniquely identify this module
    GUID = 'ceaa896d-b51f-435b-a428-91515fcb3710'
    
    # Author of this module
    Author = 'Azure Guest Configuration'
    
    # Company or vendor of this module
    CompanyName = 'MicrosoftCorporation'
    
    # Copyright statement for this module
    Copyright = '(c) 2020 Microsoft Corporation. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'Use Pester language to perform Guest Configuration audits'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'
    
    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @('Pester')
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @()
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()
    
    # DSC resources to export from this module
    DscResourcesToExport = @( 'PesterResource' )
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
    
        PSData = @{}
        # End of PSData hashtable
    
    } # End of PrivateData hashtable
    
    }
    