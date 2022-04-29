function Resolve-RelativePath
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path
    )

    $currentLocation = Get-Location
    $fullPath = [System.IO.Path]::GetFullPath($Path, $currentLocation)
    return $fullPath
}
