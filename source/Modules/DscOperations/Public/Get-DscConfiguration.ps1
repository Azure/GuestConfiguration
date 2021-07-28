<#
    .SYNOPSIS
        Get DSC configuration.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Get-DscConfiguration -ConfigurationName WindowsTLS
#>

function Get-DscConfiguration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ConfigurationName
    )

    Remove-Item (Get-GuestConfigLogPath) -ErrorAction SilentlyContinue -Force
    Remove-Item (Get-GuestConfigAssignmentReportFolderPath -ConfigurationName $ConfigurationName) -ErrorAction SilentlyContinue -Force -Recurse

    $gcWorkerPath = Get-GuestConfigWorkerBinaryPath
    Start-Process $gcWorkerPath -ArgumentList  "-o run_consistency -a  $ConfigurationName -r -c Pending" -Wait -NoNewWindow
    Start-Sleep -Seconds 1
    Write-GCOperationConsoleMessages -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)

    $reportPath = Get-GuestConfigAssignmentReportFilePath -ConfigurationName $ConfigurationName
    return ConvertFrom-Json (Get-Content $reportPath -Raw)
}
