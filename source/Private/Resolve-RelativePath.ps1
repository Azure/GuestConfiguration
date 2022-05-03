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

    # This one doesn't work in PS 5.1
    #$currentLocation = Get-Location
    #$fullPath = [System.IO.Path]::GetFullPath($Path, $currentLocation)

    # This doesn't work when the path doesn't exist yet
    #$fullPath = Convert-Path -Path $Path

    $fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    return $fullPath
}
