function Write-GCOperationConsoleMessages
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param ()

    $logPath = Get-GuestConfigLogPath

    # Sometimes OS doesn't flush the logs into file, even after the gc_worker process is exited.
    # wait for the log file to be created for 10 seconds.
    $startTime = [DateTime]::Now
    Get-Content 'C:\programdata\GuestConfig\gc_agent_logs\gc_worker.log' | Write-Warning
    do
    {
        if(Test-Path $logPath -ErrorAction SilentlyContinue) {
            # do not check  in this
            Write-Warning "found the log file at $logPath"
            break;
        }

        Start-Sleep -Seconds 1
        # do not check  in this
        Write-Warning "the log file is not found at $logPath"
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
