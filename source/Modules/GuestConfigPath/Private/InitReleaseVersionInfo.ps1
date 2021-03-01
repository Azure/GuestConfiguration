
function InitReleaseVersionInfo
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Version
    )

    $global:ReleaseVersion = $Version
}
