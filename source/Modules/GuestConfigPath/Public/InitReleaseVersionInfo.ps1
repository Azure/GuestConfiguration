
function InitReleaseVersionInfo
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Version
    )
    # $MyInvocation.MyCommand.Module.Version
    $global:ReleaseVersion = $Version
}
