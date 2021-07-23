function Get-GuestConfigWorkerBinaryPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param ()

    $gcBinPath = Get-GuestConfigBinaryPath
    $gcWorkerPath = Join-Path $gcBinPath 'gc_worker.exe'

    if (-not $IsWindows)
    {
        $gcWorkerPath = Join-Path $gcBinPath 'gc_worker'
    }

    $gcWorkerPath
}
