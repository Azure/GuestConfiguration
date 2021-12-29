
<#
    .SYNOPSIS
        Tests whether or not the given Guest Configuration package is compliant on the current machine.

    .PARAMETER Path
        The path to the Guest Configuration package file (.zip) to test.

    .PARAMETER Parameter
        A list of hashtables describing the parameters to use when running the package.

        Example:
        $Parameter = @(
            @{
                ResourceType = "Service"            # dsc configuration resource type (mandatory)
                ResourceId = 'windowsService'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Name"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'winrm'     # dsc configuration resource property value (mandatory)
            }
        )

    .EXAMPLE
        Test-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip

    .EXAMPLE
        $Parameter = @(
            @{
                ResourceType = "Service"            # dsc configuration resource type (mandatory)
                ResourceId = 'windowsService'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Name"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'winrm'     # dsc configuration resource property value (mandatory)
            })

        Test-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip -Parameter $Parameter

    .OUTPUTS
        Returns a PSCustomObject with the compliance details.
#>

function Test-GuestConfigurationPackage
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

    if ($IsMacOS)
    {
        throw 'The Test-GuestConfigurationPackage cmdlet is not supported on MacOS'
    }

    $invokeParameters = @{
        Path = $Path
    }

    if ($null -ne $Parameters)
    {
        $invokeParameters['Parameters'] = $Parameters
    }

    $result = Invoke-GuestConfigurationPackage @invokeParameters

    return $result
}
