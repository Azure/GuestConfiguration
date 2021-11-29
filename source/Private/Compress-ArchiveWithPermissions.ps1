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

    .PARAMETER CompressionLevel
        The compression level.
        The options are Fastest, Optimal, and NoCompression.
        The default value is Fastest.

    .PARAMETER IncludeBaseDirectory
        If specified the base directory will be included in the zip file.

    .EXAMPLE
        Compress-ArchiveWithPermissions -Path C:\MyDir -DestinationPath C:\MyDir.zip

#>
function Compress-ArchiveWithPermissions
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DestinationPath,

        [Parameter()]
        [System.IO.Compression.CompressionLevel]
        $CompressionLevel = [System.IO.Compression.CompressionLevel]::Fastest,

        [Parameter()]
        [Switch]
        $IncludeBaseDirectory
    )

    $Path = [System.IO.Path]::GetFullPath($Path, $PWD).ToString()
    $DestinationPath = [System.IO.Path]::GetFullPath($DestinationPath, $PWD).ToString()

    Write-Verbose -Message "Compressing from '$Path' to '$DestinationPath' with compression level '$CompressionLevel'"
    [System.IO.Compression.ZipFile]::CreateFromDirectory($Path, $DestinationPath, $CompressionLevel, $IncludeBaseDirectory.ToBool())
}
