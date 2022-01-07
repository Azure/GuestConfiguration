function Get-GCWorkerExePath
{
    [CmdletBinding()]
    [OutputType([String])]
    param ()

    $gcWorkerFolderPath = Get-GCWorkerRootPath
    $binFolderPath = Join-Path -Path $gcWorkerFolderPath -ChildPath 'GC'

    if ($IsWindows)
    {
        $gcWorkerExeName = 'gc_worker.exe'
    }
    else
    {
        $gcWorkerExeName = 'gc_worker'
    }

    $gcWorkerExePath = Join-Path -Path $binFolderPath -ChildPath $gcWorkerExeName

    return $gcWorkerExePath
}
