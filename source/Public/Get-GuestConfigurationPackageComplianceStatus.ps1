<#
    .SYNOPSIS
        Runs the given Guest Configuration package to retrieve the compliance status
        of the package on the current machine.

    .PARAMETER Path
        The path to the Guest Configuration package file (.zip) to run.

    .PARAMETER Parameter
        A list of hashtables describing the parameters to use when running the package.

        Basic Example:
        $Parameter = @(
            @{
                ResourceType = 'Service'
                ResourceId = 'windowsService'
                ResourcePropertyName = 'Name'
                ResourcePropertyValue = 'winrm'
            },
            @{
                ResourceType = 'Service'
                ResourceId = 'windowsService'
                ResourcePropertyName = 'Ensure'
                ResourcePropertyValue = 'Present'
            }
        )

        Technical Example:
        The Guest Configuration agent will replace parameter values in the compiled DSC configuration (.mof) file in the package before running it.
        If your compiled DSC configuration (.mof) file looked like this:

        instance of TestFile as $TestFile1ref
        {
            ModuleName = "TestFileModule";
            ModuleVersion = "1.0.0.0";
            ResourceID = "[TestFile]MyTestFile";  <--- This is both the resource type and ID
            Path = "test.txt"; <--- Here is the name of the parameter that I want to change the value of
            Content = "default";
            Ensure = "Present";
            SourceInfo = "TestFileSource";
            ConfigurationName = "TestFileConfig";
        };

        Then your parameter value would look like this:

        $Parameter = @(
            @{
                ResourceType = 'TestFile'
                ResourceId = 'MyTestFile'
                ResourcePropertyName = 'Path'
                ResourcePropertyValue = 'C:\myPath\newFile.txt'
            }
        )

    .EXAMPLE
        Get-GuestConfigurationPackageComplianceStatus -Path ./custom_policy/WindowsTLS.zip

    .EXAMPLE
        $Parameter = @(
            @{
                ResourceType = 'Service'
                ResourceId = 'windowsService'
                ResourcePropertyName = 'Name'
                ResourcePropertyValue = 'winrm'
            })

        Get-GuestConfigurationPackageComplianceStatus -Path ./custom_policy/AuditWindowsService.zip -Parameter $Parameter

    .OUTPUTS
        Returns a PSCustomObject with the compliance details.
#>

function Get-GuestConfigurationPackageComplianceStatus
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]
        $Path,

        [Parameter()]
        [Hashtable[]]
        $Parameter = @()
    )

    $invokeParameters = @{
        Path = $Path
    }

    if ($null -ne $Parameter)
    {
        $invokeParameters['Parameter'] = $Parameter
    }

    $result = Invoke-GuestConfigurationPackage @invokeParameters

    return $result
}
