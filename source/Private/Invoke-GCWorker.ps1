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
    $gcWorkerFolderPath = Join-Path -Path $PSScriptRoot -ChildPath 'gcworker'
    $gcLogPath = Join-Path -Path $gcWorkerFolderPath -ChildPath 'logs'

    if (Test-Path -Path $gcLogPath)
    {
        $null = Remove-Item -Path $gcLogPath -Recurse -Force
    }

    # Execute the publish operation through GC worker
    $gcWorkerExePath = Get-GuestWorkerExePath
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
        $null = Start-Process -FilePath $gcWorkerExePath -ArgumentList $Arguments -Wait -NoNewWindow
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
