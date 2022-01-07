function Invoke-GCWorker
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Arguments
    )

    # Remove the logs if needed
    $gcWorkerFolderPath = Get-GCWorkerRootPath
    $gcLogPath = Join-Path -Path $gcWorkerFolderPath -ChildPath 'logs'
    $standardOutputPath = Join-Path -Path $gcLogPath -ChildPath 'gcworker_stdout.txt'

    if (Test-Path -Path $gcLogPath)
    {
        $null = Remove-Item -Path $gcLogPath -Recurse -Force
    }

    # Execute the publish operation through GC worker
    $gcWorkerExePath = Get-GCWorkerExePath
    $gcEnvPath = Split-Path -Path $gcWorkerExePath -Parent

    $originalEnvPath = $env:Path

    $envPathPieces = $env:Path -split ';'
    if ($envPathPieces -notcontains $gcEnvPath)
    {
        $env:Path = "$originalEnvPath;$gcEnvPath"
    }

    try
    {
        Write-Verbose -Message "Invoking GC worker with the arguments '$Arguments'"
        $null = Start-Process -FilePath $gcWorkerExePath -ArgumentList $Arguments -Wait -NoNewWindow -RedirectStandardOutput $standardOutputPath
    }
    finally
    {
        $env:Path = $originalEnvPath
    }

    # Wait for streams to close
    Start-Sleep -Seconds 1

    # Write output
    Write-GuestConfigurationLogsToConsole
}
