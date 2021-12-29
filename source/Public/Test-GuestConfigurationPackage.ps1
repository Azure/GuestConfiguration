
<#
    .SYNOPSIS
        Tests whether a Guest Configuration package is compliant on the current machine or not.

    .PARAMETER Path
        The path of the zipped Guest Configuration package to test.

    .PARAMETER Parameter
        A list of hashtables describing the parameters to use when running the package.

        Example:
        $Parameter = @(
            @{
                ResourceType = "Service"            # dsc configuration resource type (mandatory)
                ResourceId = 'windowsService'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Name"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'winrm'     # dsc configuration resource property value (mandatory)
            }
        )

    .EXAMPLE
        Test-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip

        $Parameter = @(
            @{
                ResourceType = "Service"            # dsc configuration resource type (mandatory)
                ResourceId = 'windowsService'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Name"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'winrm'     # dsc configuration resource property value (mandatory)
            })

        Test-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip -Parameter $Parameter

    .OUTPUTS
        Returns compliance details.
#>

function Test-GuestConfigurationPackage
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]
        $Path,

        [Parameter()]
        [Hashtable[]]
        $Parameter = @()
    )

    if ($IsMacOS)
    {
        throw 'The Test-GuestConfigurationPackage cmdlet is not supported on MacOS'
    }

    $Path = [System.IO.Path]::GetFullPath($Path)

    #-----VALIDATE PACKAGE SETUP-----

    if (-not (Test-Path -Path $Path -PathType 'Leaf'))
    {
        throw "No zip file found at the path '$Path'. Please specify the file path to a compressed Guest Configuration package (.zip) with the Path parameter."
    }

    $sourceZipFile = Get-Item -Path $Path

    if ($sourceZipFile.Extension -ine '.zip')
    {
        throw "The file found at the path '$Path' is not a .zip file. It has extension '$($sourceZipFile.Extension)'. Please specify the file path to a compressed Guest Configuration package (.zip) with the Path parameter."
    }

    # Extract the package
    Install-GuestConfigurationWorker

    $gcWorkerPath = Join-Path -Path $PSScriptRoot -ChildPath 'gcworker'
    $gcWorkerPackagesFolderPath = Join-Path -Path $gcWorkerPath -ChildPath 'packages'

    $packageName = $sourceZipFile.BaseName
    $packageInstallPath = Join-Path -Path $gcWorkerPackagesFolderPath -ChildPath $packageName

    if (Test-Path -Path $packageInstallPath)
    {
        $null = Remove-Item -Path $packageInstallPath -Recurse -Force
    }

    $null = Expand-Archive -Path $Path -DestinationPath $packageInstallPath -Force

    # Validate mof
    $mofFileName = "$packageName.mof"
    $mofFilePath = Join-Path -Path $packageInstallPath -ChildPath $mofFileName

    if (-not (Test-Path -Path $mofFilePath -PathType 'Leaf'))
    {
        throw "No .mof file found in the package. The Guest Configuration package must include a compiled DSC configuration (.mof) with the same name as the package. Please use the New-GuestConfigurationPackage cmdlet to generate a valid package."
    }

    # Validate dependencies
    $resourceDependencies = @( Get-ResouceDependenciesFromMof -MofFilePath $mofFilePath )

    if ($resourceDependencies.Count -le 0)
    {
        throw "Failed to determine resource dependencies from the .mof file in the package. The Guest Configuration package must include a compiled DSC configuration (.mof) with the same name as the package. Please use the New-GuestConfigurationPackage cmdlet to generate a valid package."
    }

    $usingInSpecResource = $false
    $moduleDependencies = @()
    $inSpecProfileNames = @()

    $modulesFolderPath = Join-Path -Path $packageInstallPath -ChildPath 'Modules'

    foreach ($resourceDependency in $resourceDependencies)
    {
        if ($resourceDependency['ResourceName'] -ieq 'MSFT_ChefInSpecResource')
        {
            $usingInSpecResource = $true
            $inSpecProfileNames += $resourceDependency['ResourceInstanceName']
            continue
        }

        $getModuleDependenciesParameters = @{
            ModuleName = $resourceDependency['ModuleName']
            ModuleVersion = $resourceDependency['ModuleVersion']
            ModuleSourcePath = $modulesFolderPath
        }

        $moduleDependencies += Get-ModuleDependencies @getModuleDependenciesParameters
    }

    if ($moduleDependencies.Count -gt 0)
    {
        Write-Verbose -Message "Found the module dependencies: $($moduleDependencies.Name)"
    }

    $duplicateModules = @( $moduleDependencies | Group-Object -Property 'Name' | Where-Object { $_.Count -gt 1 } )

    foreach ($duplicateModule in $duplicateModules)
    {
        $uniqueVersions = @( $duplicateModule.Group.Version | Get-Unique )

        if ($uniqueVersions.Count -gt 1)
        {
            $moduleName = $duplicateModule.Group[0].Name
            throw "Cannot include more than one version of a module in one package. Detected versions $uniqueVersions of the module '$moduleName' are needed for this package."
        }
    }

    if ($usingInSpecResource)
    {
        $metaConfigName = "$packageName.metaconfig.json"
        $metaConfigPath = Join-Path -Path $packageInstallPath -ChildPath $metaConfigName
        $metaConfigContent = Get-Content -Path $metaConfigPath -Raw
        $metaConfig = $metaConfigContent | ConvertFrom-Json
        $packageType = $metaConfig.Type

        if ($packageType -ieq 'AuditAndSet')
        {
            throw "The type of this package was specified as 'AuditAndSet', but native InSpec resource was detected in the provided .mof file. This resource does not currently support the set scenario and can only be used for 'Audit' packages."
        }

        Write-Verbose -Message "Expecting the InSpec profiles: $($inSpecProfileNames)"

        foreach ($expectedInSpecProfileName in $inSpecProfileNames)
        {
            $inSpecProfilePath = Join-Path -Path $modulesFolderPath -ChildPath $expectedInSpecProfileName
            $inSpecProfile = Get-Item -Path $inSpecProfilePath -ErrorAction 'SilentlyContinue'

            if ($null -eq $inSpecProfile)
            {
                throw "Expected to find an InSpec profile at the path '$inSpecProfilePath', but there is no item at this path."
            }
            elseif ($inSpecProfile -isnot [System.IO.DirectoryInfo])
            {
                throw "Expected to find an InSpec profile at the path '$inSpecProfilePath', but the item at this path is not a directory."
            }
            else
            {
                $inSpecProfileYmlFileName = 'inspec.yml'
                $inSpecProfileYmlFilePath = Join-Path -Path $inSpecProfilePath -ChildPath $inSpecProfileYmlFileName

                if (Test-Path -Path $inSpecProfileYmlFilePath -PathType 'Leaf')
                {
                    $inSpecProfileSourcePaths += $inSpecProfilePath
                }
                else
                {
                    throw "Expected to find an InSpec profile at the path '$inSpecProfilePath', but there file named '$inSpecProfileYmlFileName' under this path."
                }
            }
        }
    }

    #-----RUN PACKAGE-----

    # Update package metaconfig to use debug mode and force module imports
    $metaconfigName = "$packageName.metaconfig.json"
    $metaconfigPath = Join-Path -Path $packageInstallPath -ChildPath $metaconfigName
    $propertiesToUpdate = @{
        debugMode = 'ForceModuleImport'
    }

    Set-MetaconfigProperty -MetaconfigPath $metaconfigPath -Property $propertiesToUpdate

    # Update package configuration parameters
    if ($null -ne $Parameter -and $Parameter.Count -gt 0)
    {
        Set-GuestConfigurationPackageParameters -Path $mofFilePath -Parameter $Parameter
    }

    # Publish the package via GC worker
    Publish-GCWorkerAssignment -PackagePath $packageInstallPath

    # Set GC worker settings for the package
    Set-GCWorkerSettings -PackagePath $packageInstallPath

    # Invoke GC worker
    $result = Invoke-GCWorkerRun -ConfigurationName $packageName

    return $result
}

function Install-GuestConfigurationWorker
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [Switch]
        $Force
    )

    $workerInstallPath = Join-Path -Path $PSScriptRoot -ChildPath 'gcworker'
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

        if ($IsWindows)
        {
            $windowsPackageSourcePath = Join-Path -Path $binFolderSourcePath -ChildPath 'DSC_Windows.zip'
            $null = Expand-Archive -Path $windowsPackageSourcePath -DestinationPath $binFolderDestinationPath
        }
        else
        {
            # The Linux package contains an additional folder level
            $linuxPackageSourcePath = Join-Path -Path $binFolderSourcePath -ChildPath 'DSC_Linux.zip'
            $null = Expand-Archive -Path $linuxPackageSourcePath -DestinationPath $binFolderDestinationPath

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
        }

        $logPath = Join-Path -Path $logsFolderPath -ChildPath 'gc_worker.log'
        $telemetryPath = Join-Path -Path $logsFolderPath -ChildPath 'gc_worker_telemetry.txt'
        $configurationsFolderPath = Join-Path -Path $workerInstallPath -ChildPath 'Configurations'
        $modulePath = Join-Path -Path $binFolderDestinationPath -ChildPath 'Modules'

        # The directory paths in gc.config must have trailing slashes
        $basePath = $workerInstallPath + '\'
        $binPath = $binFolderDestinationPath + '\'
        $configurationsFolderPath = $configurationsFolderPath + '\'
        $modulePath = $modulePath + '\'

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
        Write-Verbose -Message "Creating the logs folder at '$logsFolderPath'" -Verbose
        $null = New-Item -Path $logsFolderPath -ItemType 'Directory'
    }
}

function Set-GuestConfigurationPackageParameters
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    if ($Parameter.Count -eq 0)
    {
        return
    }

    $mofInstances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Path, 4)

    foreach ($parameterInfo in $Parameter)
    {
        if (-not $parameterInfo.ContainsKey('ResourceType'))
        {
            throw "Policy parameter is missing a mandatory property 'ResourceType'. Please make sure that configuration resource type is specified in configuration parameter."
        }

        if (-not $parameterInfo.ContainsKey('ResourceId'))
        {
            throw "Policy parameter is missing a mandatory property 'ResourceId'. Please make sure that configuration resource Id is specified in configuration parameter."
        }

        if (-not $parameterInfo.ContainsKey('ResourcePropertyName'))
        {
            throw "Policy parameter is missing a mandatory property 'ResourcePropertyName'. Please make sure that configuration resource property name is specified in configuration parameter."
        }

        if (-not $parameterInfo.ContainsKey('ResourcePropertyValue'))
        {
            throw "Policy parameter is missing a mandatory property 'ResourcePropertyValue'. Please make sure that configuration resource property value is specified in configuration parameter."
        }

        $resourceId = "[$($parameterInfo.ResourceType)]$($parameterInfo.ResourceId)"

        $matchingMofInstance = @( $mofInstances | Where-Object {
            ($_.CimInstanceProperties.Name -contains 'ResourceID') -and
            ($_.CimInstanceProperties['ResourceID'].Value -ieq $resourceId) -and
            ($_.CimInstanceProperties.Name -icontains $parameterInfo.ResourcePropertyName)
        })

        if ($null -eq $matchingMofInstance -or $matchingMofInstance.Count -eq 0)
        {
            throw "Failed to find a matching parameter reference with ResourceType:'$($parameterInfo.ResourceType)', ResourceId:'$($parameterInfo.ResourceId)' and ResourcePropertyName:'$($parameterInfo.ResourcePropertyName)' in the configuration. Please ensure that this resource instance exists in the configuration."
        }

        if ($matchingMofInstance.Count -gt 1)
        {
            throw "Found more than one matching parameter reference with ResourceType:'$($parameterInfo.ResourceType)', ResourceId:'$($parameterInfo.ResourceId)' and ResourcePropertyName:'$($parameterInfo.ResourcePropertyName)'. Please ensure that only one resource instance with this information exists in the configuration."
        }

        $mofInstanceParameter = $matchingMofInstance[0].CimInstanceProperties.Item($parameterInfo.ResourcePropertyName)
        $mofInstanceParameter.Value = $parameterInfo.ResourcePropertyValue
    }

    Write-MofContent -MofInstances $mofInstances -OutputPath $Path
}
