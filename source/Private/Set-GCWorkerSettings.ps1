function Set-GCWorkerSettings
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PackagePath
    )

    if (-not (Test-Path -Path $PackagePath))
    {
        throw "No Guest Configuration package found at the path '$PackagePath'"
    }

    $PackagePath = Resolve-RelativePath -Path $PackagePath
    $packageName = [System.IO.Path]::GetFileNameWithoutExtension($PackagePath)

    if ($PackagePath.EndsWith([System.IO.Path]::DirectorySeparatorChar))
    {
        $PackagePath = $PackagePath.TrimEnd([System.IO.Path]::DirectorySeparatorChar)
    }

    $arguments = "-o set_agent_settings -a $packageName -p `"$PackagePath`""

    Invoke-GCWorker -Arguments $arguments
}
