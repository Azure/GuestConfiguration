function Get-GCWorkerRootPath
{
    [CmdletBinding()]
    [OutputType([String])]
    param ()

    $gcWorkerRootPath = Join-Path -Path $PSScriptRoot -ChildPath 'gcworker'
    return $gcWorkerRootPath
}
