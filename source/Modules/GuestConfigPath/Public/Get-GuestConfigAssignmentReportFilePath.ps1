function Get-GuestConfigAssignmentReportFilePath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ConfigurationName
    )

    $guestConfigReportFolderPath = Get-GuestConfigAssignmentReportFolderPath -ConfigurationName $ConfigurationName

    $reportFilePath = Join-Path $guestConfigReportFolderPath "$($ConfigurationName)_Compliant.json"
    if(Test-Path $reportFilePath) {
        return $reportFilePath
    }

    $reportFilePath = Join-Path $guestConfigReportFolderPath "$($ConfigurationName)_NonCompliant.json"
    if(Test-Path $reportFilePath) {
        return $reportFilePath
    }

    throw "Failed to find assignment report at '$($guestConfigReportFolderPath)' location"
}
