function Get-GuestConfigAssignmentReportFolderPath
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

    $binRootFolder = Get-GuestConfigBinaryRootPath
    $releaseVersionfolder = Join-Path -Path $binRootFolder -ChildPath $global:ReleaseVersion
    $guestConfigReportFolderPath = Join-Path -Path $releaseVersionfolder -ChildPath 'reports'
    return $guestConfigReportFolderPath
}
