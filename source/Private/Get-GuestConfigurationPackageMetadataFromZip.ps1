function Get-GuestConfigurationPackageMetadataFromZip
{
    [CmdletBinding()]
    [OutputType([PSObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Io.FileInfo]
        $Path
    )

    $Path = [System.IO.Path]::GetFullPath($Path) # Get Absolute path as .Net methods don't like relative paths.

    try
    {
        $tempFolderPackage = Join-Path -Path ([io.path]::GetTempPath()) -ChildPath ([guid]::NewGuid().Guid)
        Expand-Archive -LiteralPath $Path -DestinationPath $tempFolderPackage -Force
        Get-GuestConfigurationPackageMetaConfig -Path $tempFolderPackage
    }
    finally
    {
        # Remove the temporarily extracted package
        Remove-Item -Force -Recurse $tempFolderPackage -ErrorAction SilentlyContinue
    }
}
