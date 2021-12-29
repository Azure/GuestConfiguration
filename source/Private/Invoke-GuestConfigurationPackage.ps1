function Invoke-GuestConfigurationPackage
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
        $Parameter = @(),

        [Parameter()]
        [Switch]
        $Apply
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

                if (-not (Test-Path -Path $inSpecProfileYmlFilePath -PathType 'Leaf'))
                {
                    throw "Expected to find an InSpec profile at the path '$inSpecProfilePath', but there is no file named '$inSpecProfileYmlFileName' under this path."
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
    $result = Invoke-GCWorkerRun -ConfigurationName $packageName -Apply:$Apply

    return $result
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
