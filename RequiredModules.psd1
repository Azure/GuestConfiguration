@{
    PSDependOptions             = @{
        AddToPath  = $true
        Target     = 'output\RequiredModules'
        Parameters = @{
            Repository = 'PSGallery'
        }
    }

    InvokeBuild                 = 'latest'
    PSScriptAnalyzer            = 'latest'
    Pester                      = 'latest'
    Plaster                     = 'latest'
    ModuleBuilder               = 'latest'
    ChangelogManagement         = 'latest'
    Sampler                     = @{
        version = 'latest'
        Parameters = @{
            AllowPrerelease = $true
        }
    }
    MarkdownLinkCheck             = 'latest'
    'Sampler.GitHubTasks'         = 'latest'
    'DscResource.Test'            = 'latest'
    'DscResource.AnalyzerRules'   = 'latest'
    xDscResourceDesigner          = 'latest'
    'DscResource.DocGenerator'    = 'latest'
    'Az.Accounts'                 = 'latest'
    'Az.Resources'                = 'latest'
    'Az.Storage'                  = 'latest'
    'PSDesiredStateConfiguration' = 'latest'

    ComputerManagementDsc         = '8.2.0' # this is what the test MOF requires.
}
