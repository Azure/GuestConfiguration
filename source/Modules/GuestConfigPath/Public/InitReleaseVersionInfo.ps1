
function InitReleaseVersionInfo
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Version
    )

    $global:ReleaseVersion = $Version
}
