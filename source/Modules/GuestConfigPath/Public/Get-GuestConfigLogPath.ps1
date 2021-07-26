function Get-GuestConfigLogPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param ()

    $logFolder = Join-Path -Path (Get-GuestConfigPath) -ChildPath 'gc_agent_logs'
    $logPath = Join-Path -Path $logFolder -ChildPath 'gc_agent.json'

    return $logPath
}
