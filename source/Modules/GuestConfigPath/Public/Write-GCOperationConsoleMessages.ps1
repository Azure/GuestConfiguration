function Write-GCOperationConsoleMessages
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param ()

    $logPath = Get-GuestConfigLogPath
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
