function Install-GCWorker
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [Switch]
        $Force
    )

    $workerInstallPath = Get-GCWorkerRootPath
    $logsFolderPath = Join-Path -Path $workerInstallPath -ChildPath 'logs'

    if (Test-Path -Path $workerInstallPath -PathType 'Container')
    {
        if ($Force)
        {
            $null = Remove-Item -Path $workerInstallPath -Recurse -Force
            $null = New-Item -Path $workerInstallPath -ItemType 'Directory'
        }
    }
    else
    {
        $null = New-Item -Path $workerInstallPath -ItemType 'Directory'
    }

    # The worker has 'GC' hard-coded internally, so if you change this file name, it will not work
    $binFolderDestinationPath = Join-Path -Path $workerInstallPath -ChildPath 'GC'

    if (-not (Test-Path -Path $binFolderDestinationPath -PathType 'Container'))
    {
        $null = New-Item -Path $binFolderDestinationPath -ItemType 'Directory'

        $binFolderSourcePath = Join-Path -Path $PSScriptRoot -ChildPath 'bin'

        $os = Get-OSPlatform

        if ($os -ieq 'Windows')
        {
            $windowsPackageSourcePath = Join-Path -Path $binFolderSourcePath -ChildPath 'DSC_Windows.zip'
            $null = Expand-Archive -Path $windowsPackageSourcePath -DestinationPath $binFolderDestinationPath
        }
        else
        {
            # The Linux package contains an additional folder level
            $linuxPackageSourcePath = Join-Path -Path $binFolderSourcePath -ChildPath 'DSC_Linux.zip'
            $null = Expand-Archive -Path $linuxPackageSourcePath -DestinationPath $workerInstallPath

            if (-not (Test-Path -Path $binFolderDestinationPath -PathType 'Container'))
            {
                throw "Linux agent package structure has changed. Expected a 'GC' folder within the package but the folder '$binFolderDestinationPath' does not exist."
            }

            # Fix for “LTTng-UST: Error (-17) while registering tracepoint probe. Duplicate registration of tracepoint probes having the same name is not allowed.”
            $tracePointProviderLibPath = Join-Path -Path $binFolderDestinationPath -ChildPath 'libcoreclrtraceptprovider.so'

            if (Test-Path -Path $tracePointProviderLibPath)
            {
                $null = Remove-Item -Path $tracePointProviderLibPath -Force
            }

            $bashFilesInBinFolder = @(Get-ChildItem -Path $binFolderDestinationPath -Filter "*.sh" -Recurse)

            foreach ($bashFileInBinFolder in $bashFilesInBinFolder)
            {
                chmod '+x' $bashFileInBinFolder.FullName
            }

            # Give root user permission to execute gc_worker
            chmod 700 $binFolderDestinationPath

            $gcWorkerExePath = Join-Path -Path $binFolderDestinationPath -ChildPath 'gc_worker'
            chmod '+x' $gcWorkerExePath
        }

        $logPath = Join-Path -Path $logsFolderPath -ChildPath 'gc_worker.log'
        $telemetryPath = Join-Path -Path $logsFolderPath -ChildPath 'gc_worker_telemetry.txt'
        $configurationsFolderPath = Join-Path -Path $workerInstallPath -ChildPath 'Configurations'
        $modulePath = Join-Path -Path $binFolderDestinationPath -ChildPath 'Modules'

        # The directory paths in gc.config must have trailing slashes
        $basePath = $workerInstallPath + [System.IO.Path]::DirectorySeparatorChar
        $binPath = $binFolderDestinationPath + [System.IO.Path]::DirectorySeparatorChar
        $configurationsFolderPath = $configurationsFolderPath + [System.IO.Path]::DirectorySeparatorChar
        $modulePath = $modulePath + [System.IO.Path]::DirectorySeparatorChar

        # Save GC config settings file
        $gcConfig = @{
            "DoNotSendReport" = $true
            "SaveLogsInJsonFormat" = $true
            "Paths" = @{
                "BasePath" = $basePath
                "DotNetFrameworkPath" = $binPath
                "UserConfigurationsPath" = $configurationsFolderPath
                "ModulePath" = $modulePath
                "LogPath" = $logPath
                "TelemetryPath" = $telemetryPath
            }
        }

        $gcConfigContent = $gcConfig | ConvertTo-Json

        $gcConfigPath = Join-Path -Path $binFolderDestinationPath -ChildPath 'gc.config'
        $null = Set-Content -Path $gcConfigPath -Value $gcConfigContent -Encoding 'ascii' -Force
    }
    else
    {
        Write-Verbose -Message "Guest Configuration worker binaries already installed at '$binFolderDestinationPath'"
    }

    if (-not (Test-Path -Path $logsFolderPath -PathType 'Container'))
    {
        Write-Verbose -Message "Creating the logs folder at '$logsFolderPath'"
        $null = New-Item -Path $logsFolderPath -ItemType 'Directory'
    }
}
