using namespace System.IO.Compression.ZipFile

<#
    .SYNOPSIS
        Create an Zip file from a Directory, including hidden files and folders.

    .DESCRIPTION
        The Compress-Archive is not copying hidden files and Directory by default,
        and it can be tricky to make it work without losing the Directory structure.
        However the `[System.IO.Compression.ZipFile]::CreateFromDirectory()` method
        makes it possible, and this function is a wrapper for it.
        The reason for creating a wrapper is to simplify testing via mocking.

    .PARAMETER Path
        Path of the File or Directory to compress.

    .PARAMETER DestinationPath
        Destination file to Zip the Directory into.

    .PARAMETER CompressionLevel
        Compression level between Fastest, Optimal, and NoCompression.

    .PARAMETER IncludeBaseDirectory
        Whether you want the zip to include the Directory and its content in the zip,
        or if you only want the content of the Directory to be at the zip's root (default).

    .PARAMETER Force
        Delete the destination file if it already exists.

    .EXAMPLE
        PS C:\> Compress-ArchiveByDirectory -Path C:\MyDir -DestinationPath C:\MyDir.zip -CompressionLevel Fastest -IncludeBaseDirectory -Force

#>
function Compress-ArchiveByDirectory
{
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DestinationPath,

        [Parameter()]
        [System.IO.Compression.CompressionLevel]
        $CompressionLevel = [System.IO.Compression.CompressionLevel]::Fastest,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeBaseDirectory,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    if (-not  (Split-Path -IsAbsolute -Path $DestinationPath))
    {
        $DestinationPath = Join-Path -Path (Get-Location -PSProvider fileSystem) -ChildPath $DestinationPath
    }

    if ($PSBoundParameters.ContainsKey('Force') -and $true -eq $PSBoundParameters['Force'])
    {
        if ((Test-Path -Path $DestinationPath) -and $PSCmdlet.ShouldProcess("Deleting Zip file '$DestinationPath'.", $DestinationPath, 'Remove-Item -Force'))
        {
            Remove-Item -Force $DestinationPath -ErrorAction Stop
        }
    }

    if ($PSCmdlet.ShouldProcess("Zipping '$Path' to '$DestinationPath' with compression level '$CompressionLevel', includig base dir: '$($IncludeBaseDirectory.ToBool())'.", $Path, 'ZipFile'))
    {
        [System.IO.Compression.ZipFile]::CreateFromDirectory($Path, $DestinationPath, $CompressionLevel, $IncludeBaseDirectory.ToBool())
    }
}
