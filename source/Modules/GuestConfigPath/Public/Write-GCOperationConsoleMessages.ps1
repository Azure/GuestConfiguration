function Write-GCOperationConsoleMessages
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param ()

    $logPath = Get-GuestConfigLogPath

    # Sometimes OS doesn't flush the logs into file, even after the gc_worker process is exited.
    # wait for the log file to be created for 10 seconds.
    $startTime = [DateTime]::Now
    do
    {
        if(Test-Path $logPath -ErrorAction SilentlyContinue) {
            break;
        }

        Start-Sleep -Seconds 1
    } until (([DateTime]::Now - $startTime).Seconds -gt 10)

    $logs = ConvertFrom-Json (Get-Content $logPath -Raw)
    $logs | % {
        if($_.type -eq 'warning')
        {
            Write-Warning $_.message
        }
        elseif($_.type -eq 'error')
        {
            Write-Error $_.message
        }
        else
        {
            Write-Verbose $_.message
        }
    }
}
