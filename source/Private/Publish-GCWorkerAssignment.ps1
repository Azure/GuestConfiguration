function Publish-GCWorkerAssignment
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PackagePath
    )

    if (-not (Test-Path -Path $PackagePath))
    {
        throw "No Guest Configuration package found at the path '$PackagePath'"
    }

    $PackagePath = Resolve-Path -Path $PackagePath
    $packageName = Split-Path -Path $PackagePath -LeafBase

    if (-not ($PackagePath.EndsWith([System.IO.Path]::DirectorySeparatorChar)))
    {
        $PackagePath = $PackagePath + [System.IO.Path]::DirectorySeparatorChar
    }

    $arguments = "-o publish_assignment -a $packageName -p $PackagePath"

    Invoke-GCWorker -Arguments $arguments
}
