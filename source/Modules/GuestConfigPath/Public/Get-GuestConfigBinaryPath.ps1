function Get-GuestConfigBinaryPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param ()

    $binRootFolder = Get-GuestConfigBinaryRootPath
    $releaseVersionfolder = Join-Path -Path $binRootFolder -ChildPath $global:ReleaseVersion
    $guestConfigBinaryPath = Join-Path -Path $releaseVersionfolder -ChildPath 'GC'
    Write-Debug -Message "Guest Config Binary Path is: '$guestConfigBinaryPath'."

    $guestConfigBinaryPath
}
