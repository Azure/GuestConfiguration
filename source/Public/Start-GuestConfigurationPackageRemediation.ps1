
<#
    .SYNOPSIS
        Applies the given Guest Configuration package file (.zip) to the current machine.

    .PARAMETER Path
        The path to the Guest Configuration package file (.zip) to apply.

    .PARAMETER Parameter
        A list of hashtables describing the parameters to use when applying the package.

        Example:
        $Parameter = @(
            @{
                ResourceType = "Service"            # dsc configuration resource type (mandatory)
                ResourceId = 'windowsService'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Name"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'winrm'     # dsc configuration resource property value (mandatory)
            }
        )

    .PARAMETER Force
        Allows cmdlet to make changes on machine for remediation that cannot otherwise be changed.

    .EXAMPLE
        Start-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip -Force

    .EXAMPLE
        $Parameter = @(
            @{
                ResourceType = "MyFile"            # dsc configuration resource type (mandatory)
                ResourceId = 'hi'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Ensure"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'Present'     # dsc configuration resource property value (mandatory)
            })

        Start-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip -Parameter $Parameter -Force

    .OUTPUTS
        None.
#>

function Start-GuestConfigurationPackageRemediation
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [Hashtable[]]
        $Parameter = @(),

        [Parameter()]
        [Switch]
        $Force
    )

    if ($IsMacOS)
    {
        throw 'The Start-GuestConfigurationPackageRemediation cmdlet is not supported on MacOS'
    }

    $invokeParameters = @{
        Path = $Path
        Apply = $true
    }

    if ($null -ne $Parameter)
    {
        $invokeParameters['Parameter'] = $Parameter
    }

    $result = Invoke-GuestConfigurationPackage @invokeParameters

    return $result
}
