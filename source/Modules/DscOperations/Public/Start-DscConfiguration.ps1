<#
    .SYNOPSIS
        Start DSC configuration.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Start-DscConfiguration -ConfigurationName WindowsTLS
#>
function Start-DscConfiguration
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ConfigurationName
    )

    Remove-Item (Get-GuestConfigLogPath) -ErrorAction SilentlyContinue -Force
    Remove-Item (Get-GuestConfigAssignmentReportFolderPath -ConfigurationName $ConfigurationName) -ErrorAction SilentlyContinue -Force -Recurse

    $gcWorkerPath = Get-GuestConfigWorkerBinaryPath
    Start-Process $gcWorkerPath -ArgumentList  "-o run_consistency -a  $ConfigurationName -r -s inguest_apply_and_monitor -c Pending" -Wait -NoNewWindow
    Write-GCOperationConsoleMessages -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
}
