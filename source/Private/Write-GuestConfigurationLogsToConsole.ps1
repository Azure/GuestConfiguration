function Write-GuestConfigurationLogsToConsole
{
    [CmdletBinding()]
    param ()

    $gcWorkerFolderPath = Join-Path -Path $PSScriptRoot -ChildPath 'gcworker'
    $gcLogFolderPath = Join-Path -Path $gcWorkerFolderPath -ChildPath 'logs'
    $gcLogPath = Join-Path -Path $gcLogFolderPath -ChildPath 'gc_agent.json'

    if (Test-Path -Path $gcLogPath)
    {
        $gcLogContent = Get-Content -Path $gcLogPath -Raw
        $gcLog = $gcLogContent | ConvertFrom-Json

        foreach ($logEvent in $gcLog)
        {
            if ($logEvent.type -ieq 'warning')
            {
                Write-Warning -Message $logEvent.message
            }
            elseif ($logEvent.type -ieq 'error')
            {
                Write-Error -Message $logEvent.message
            }
            else
            {
                Write-Verbose -Message $logEvent.message
            }
        }
    }
}
