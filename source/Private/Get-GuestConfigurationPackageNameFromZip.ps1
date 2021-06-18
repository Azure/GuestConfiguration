function Get-GuestConfigurationPackageNameFromZip
{
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true)]
        [System.Io.FileInfo]
        $Path
    )

    $Path = [System.IO.Path]::GetFullPath($Path) # Get Absolute path as .Net method don't like relative paths.

    try
    {
        $zipRead = [IO.Compression.ZipFile]::OpenRead($Path)
        # Make sure we only get the MOF which is at the root of the package
        $mofFile = @() + $zipRead.Entries.FullName.Where({((Split-Path -Leaf -Path $_) -eq $_) -and $_ -match '\.mof$'})
    }
    finally
    {
        # Close the zip so we can move it.
        $zipRead.Dispose()
    }

    if ($mofFile.count -ne 1)
    {
        throw "Invalid policy package, failed to find unique dsc document in policy package downloaded from '$Uri'."
    }

    return ([System.Io.Path]::GetFileNameWithoutExtension($mofFile[0]))
}
