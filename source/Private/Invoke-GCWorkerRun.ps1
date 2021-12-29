function Invoke-GCWorkerRun
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationName,

        [Parameter()]
        [Switch]
        $ApplyConfiguration
    )

    # Remove any existing reports if needed
    $gcWorkerFolderPath = Join-Path -Path $PSScriptRoot -ChildPath 'gcworker'
    $reportsFolderPath = Join-Path -Path $gcWorkerFolderPath -ChildPath 'reports'

    if (Test-Path -Path $reportsFolderPath)
    {
        $null = Remove-Item -Path $reportsFolderPath -Recurse -Force
    }

    $arguments = "-o run_consistency -a $ConfigurationName -r -c Pending"

    if ($ApplyConfiguration)
    {
        $arguments += "-s inguest_apply_and_monitor"
    }

    Invoke-GCWorker -Arguments $arguments

    $compliantReportFileName = "{0}_Compliant.json" -f $ConfigurationName
    $compliantReportFilePath = Join-Path -Path $reportsFolderPath -ChildPath $compliantReportFileName
    $compliantReportFileExists = Test-Path -Path $compliantReportFilePath -PathType 'Leaf'

    $nonCompliantReportFileName = "{0}_NonCompliant.json" -f $ConfigurationName
    $nonCompliantReportFilePath = Join-Path -Path $reportsFolderPath -ChildPath $nonCompliantReportFileName
    $nonCompliantReportFileExists = Test-Path -Path $nonCompliantReportFilePath -PathType 'Leaf'

    if ($compliantReportFileExists -and $nonCompliantReportFileExists)
    {
        Write-Warning -Message "Both a compliant report and non-compliant report exist for the package $ConfigurationName"

        $compliantReportFile = Get-Item -Path $compliantReportFilePath
        $nonCompliantReportFile = Get-Item -Path $nonCompliantReportFilePath

        if ($compliantReportFile.LastWriteTime -gt $nonCompliantReportFile.LastWriteTime)
        {
            Write-Warning -Message "Using last compliant report since it has a later LastWriteTime"
            $reportFilePath = $compliantReportFilePath
        }
        elseif ($compliantReportFile.LastWriteTime -lt $nonCompliantReportFile.LastWriteTime)
        {
            Write-Warning -Message "Using last non-compliant report since it has a later LastWriteTime"
            $reportFilePath = $nonCompliantReportFilePath
        }
        else
        {
            throw "The reports have the same LastWriteTime. Please remove the reports under '$reportsFolderPath' and try again."
        }
    }
    elseif ($compliantReportFileExists)
    {
        $reportFilePath = $compliantReportFilePath
    }
    elseif ($nonCompliantReportFileExists)
    {
        $reportFilePath = $nonCompliantReportFilePath
    }
    else
    {
        $logPath = Join-Path -Path $gcWorkerFolderPath -ChildPath 'logs'
        throw "No report was generated. The package likely was not formed correctly or crashed. Please check the logs under the path '$logPath'."
    }

    $reportContent = Get-Content -Path $reportFilePath -Raw
    $report = $reportContent | ConvertFrom-Json

    return $report
}
