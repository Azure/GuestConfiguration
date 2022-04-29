function Get-GuestConfigurationPackageName
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Io.FileInfo]
        $Path
    )

    # Get Absolute path as .Net method don't like relative paths
    $Path = Resolve-RelativePath -Path $Path

    # Make sure we only get the MOF which is at the root of the package
    $mofFile = @() + (Get-ChildItem -Path (Join-Path -Path $Path -ChildPath *.mof) -File -ErrorAction Stop)

    if ($mofFile.Count -ne 1)
    {
        throw "Invalid GuestConfiguration Package at '$Path'. Found $($mofFile.Count) mof files."
        return
    }
    else
    {
        Write-Debug -Message "Found the MOF '$($moffile)' in $Path."
    }

    return ([System.Io.Path]::GetFileNameWithoutExtension($mofFile[0]))
}
