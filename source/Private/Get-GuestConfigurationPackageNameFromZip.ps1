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
        $mofFile = $zipRead.Entries.FullName.Where({((Split-Path -Leaf -Path $_) -eq $_) -and $_ -match '\.mof$'})
    }
    finally
    {
        # Close the zip so we can move it.
        $zipRead.Dispose()
    }

    if ($null -eq $mofFile )
    {
        throw "Invalid policy package, failed to find dsc document in policy package downloaded from '$Uri'."
    }
    elseif ($mofFile.count -gt 1)
    {
        throw "Multiple MOF files found at the root of the package."
    }

    return ([System.Io.Path]::GetFileNameWithoutExtension($mofFile))
}
