<#
    .SYNOPSIS
        Set DSC LCM settings.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Set-DscLocalConfigurationManager -Path C:\metaconfig
#>

function Set-DscLocalConfigurationManager
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ConfigurationName,

        [Parameter(Position=1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )

    Remove-Item (Get-GuestConfigLogPath) -ErrorAction SilentlyContinue -Force

    $gcWorkerPath = Get-GuestConfigWorkerBinaryPath
    Start-Process $gcWorkerPath -ArgumentList  "-o set_agent_settings -a  $ConfigurationName -p $Path" -Wait -NoNewWindow
    Write-GCOperationConsoleMessages -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
}
