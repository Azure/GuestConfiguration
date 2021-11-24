using namespace System.IO.Compression.ZipFile

<#
    .SYNOPSIS
        Creates a zip file without wiping out the item type and permissions.

    .DESCRIPTION
        The Compress-Archive and Expand-Archive cmdlets wipe out the file modes on Linux.
        This erroneously removes file permissions and the bit that determines whether the item
        is a file or a directory.
        We have created this function to avoid the errors in those cmdlets on Linux.

        The issue has been filed with PowerShell here:
        https://github.com/PowerShell/Microsoft.PowerShell.Archive/issues/36

    .PARAMETER Path
        The path of the directory to compress.

    .PARAMETER DestinationPath
        The destination path to compress the directory to.

    .PARAMETER Force
        If specified, any existing files at the destination path will be removed.

    .EXAMPLE
        Expand-ArchiveWithPermissions -Path C:\MyDir.zip -DestinationPath C:\MyDir -Force

#>
function Expand-ArchiveWithPermissions
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DestinationPath,

        [Parameter()]
        [Switch]
        $Force
    )

    Write-Verbose -Message "Expanding from '$Path' to '$DestinationPath' with force as $Force"
    [System.IO.Compression.ZipFile]::ExtractToDirectory($Path, $DestinationPath, $Force.ToBool())
}
