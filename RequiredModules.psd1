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
    'xDscResourceDesigner'        = 'latest'
    'DscResource.DocGenerator'    = 'latest'

    ComputerManagementDsc         = '8.2.0' # this is what the test MOF requires.
    PSDscResources                = '2.12.0.0' # required for tests only
    'Microsoft.PowerShell.Utility'  = 'latest' # required for PS 5.1
}
