function Reset-GCWorkerTempDirectory
{
    [CmdletBinding()]
    [OutputType([String])]
    param ()

    $gcWorkerRootPath = Get-GCWorkerRootPath
    $tempPath = Join-Path -Path $gcWorkerRootPath -ChildPath 'temp'

    if (Test-Path -Path $tempPath)
    {
        $null = Remove-Item -Path $tempPath -Recurse -Force
    }

    $null = New-Item -Path $tempPath -ItemType 'Directory' -Force

    return $tempPath
}
