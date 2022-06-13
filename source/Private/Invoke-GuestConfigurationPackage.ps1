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

    $os = Get-OSPlatform
    if ($os -ieq 'MacOS')
    {
        throw 'This cmdlet is not supported on MacOS.'
    }

    #-----VALIDATE PARAMETERS-----
    $requiredParameterProperties = @('ResourceType', 'ResourceId', 'ResourcePropertyName', 'ResourcePropertyValue')

    foreach ($parameterInfo in $Parameter)
    {
        foreach ($requiredParameterProperty in $requiredParameterProperties)
        {
            if (-not ($parameterInfo.Keys -contains $requiredParameterProperty))
            {
                $requiredParameterPropertyString = $requiredParameterProperties -join ', '
                throw "One of the specified parameters is missing the mandatory property '$requiredParameterProperty'. The mandatory properties for parameters are: $requiredParameterPropertyString"
            }

            if ($parameterInfo[$requiredParameterProperty] -isnot [string])
            {
                $requiredParameterPropertyString = $requiredParameterProperties -join ', '
                throw "The property '$requiredParameterProperty' of one of the specified parameters is not a string. All parameter property values must be strings."
            }
        }
    }

    #-----VALIDATE PACKAGE SETUP-----
    $Path = Resolve-RelativePath -Path $Path

    if (-not (Test-Path -Path $Path -PathType 'Leaf'))
    {
        throw "No zip file found at the path '$Path'. Please specify the file path to a compressed Guest Configuration package (.zip) with the Path parameter."
    }

    $sourceZipFile = Get-Item -Path $Path

    if ($sourceZipFile.Extension -ine '.zip')
    {
        throw "The file found at the path '$Path' is not a .zip file. It has extension '$($sourceZipFile.Extension)'. Please specify the file path to a compressed Guest Configuration package (.zip) with the Path parameter."
    }

    # Install the Guest Configuration worker if needed
    Install-GCWorker

    # Extract the package
    $gcWorkerPath = Get-GCWorkerRootPath
    $gcWorkerPackagesFolderPath = Join-Path -Path $gcWorkerPath -ChildPath 'packages'

    $packageInstallFolderName = $sourceZipFile.BaseName
    $packageInstallPath = Join-Path -Path $gcWorkerPackagesFolderPath -ChildPath $packageInstallFolderName

    if (Test-Path -Path $packageInstallPath)
    {
        $null = Remove-Item -Path $packageInstallPath -Recurse -Force
    }

    $null = Expand-Archive -Path $Path -DestinationPath $packageInstallPath -Force

    # Find and validate the mof file
    $mofFilePattern = '*.mof'
    $mofChildItems = @( Get-ChildItem -Path $packageInstallPath -Filter $mofFilePattern -File )

    if ($mofChildItems.Count -eq 0)
    {
        throw "No .mof file found in the package. The Guest Configuration package must include a compiled DSC configuration (.mof) with the same name as the package. Please use the New-GuestConfigurationPackage cmdlet to generate a valid package."
    }
    elseif ($mofChildItems.Count -gt 1)
    {
        throw "Found more than one .mof file in the extracted Guest Configuration package. Please remove any extra .mof files from the root of the package. Please use the New-GuestConfigurationPackage cmdlet to generate a valid package."
    }

    $mofFile = $mofChildItems[0]
    $packageName = $mofFile.BaseName

    # Get package version
    $metaconfigFileName = "{0}.metaconfig.json" -f $packageName
    $metaconfigFilePath = Join-Path -Path $packageInstallPath -ChildPath $metaconfigFileName

    if (Test-Path -Path $metaconfigFilePath)
    {
        $metaconfig = Get-Content -Path $metaconfigFilePath -Raw | ConvertFrom-Json | ConvertTo-OrderedHashtable

        if ($metaconfig.Keys -contains 'Version')
        {
            $packageVersion = $metaconfig['Version']
            Write-Verbose -Message "Package has the version $packageVersion"
        }

        if ($metaconfig.Keys -contains 'Type')
        {
            $packageType = $metaconfig['Type']
            Write-Verbose -Message "Package has the type $packageType"

            if ($packageType -eq 'Audit' -and $Apply)
            {
                throw 'The specified package has been marked as Audit-only. You cannot apply/remediate an Audit-only package. Please change the type of the package to "AuditAndSet" with New-GuestConfigurationPackage if you would like to apply/remediate with this package.'
            }
        }
        else
        {
            Write-Warning -Message "Failed to determine the package type from the metaconfig file '$metaconfigFileName' in the package. Please use the latest version of the New-GuestConfigurationPackage cmdlet to construct your package."
        }
    }
    else
    {
        Write-Warning -Message "Failed to find the metaconfig file '$metaconfigFileName' in the package. Please use the latest version of the New-GuestConfigurationPackage cmdlet to construct your package."
    }

    # Rename the package install folder to match what the GC worker expects if needed
    if ($packageName -ne $packageInstallFolderName)
    {
        $newPackageInstallPath = Join-Path -Path $gcWorkerPackagesFolderPath -ChildPath $packageName

        if (Test-Path -Path $newPackageInstallPath)
        {
            $null = Remove-Item -Path $newPackageInstallPath -Recurse -Force
        }

        $null = Rename-Item -Path $packageInstallPath -NewName $newPackageInstallPath
        $packageInstallPath = $newPackageInstallPath
    }

    $mofFilePath = Join-Path -Path $packageInstallPath -ChildPath $mofFile.Name

    # Validate dependencies
    $resourceDependencies = @( Get-MofResouceDependencies -MofFilePath $mofFilePath )

    if ($resourceDependencies.Count -le 0)
    {
        throw "Failed to determine resource dependencies from the .mof file in the package. The Guest Configuration package must include a compiled DSC configuration (.mof) with the same name as the package. Please use the New-GuestConfigurationPackage cmdlet to generate a valid package."
    }

    $usingInSpecResource = $false
    $moduleDependencies = @()
    $inSpecProfileNames = @()

    $modulesFolderPath = Join-Path -Path $packageInstallPath -ChildPath 'Modules'

    $modulesFolders = @( Get-ChildItem -Path $modulesFolderPath -Directory )
    if ($modulesFolders.Count -eq 0)
    {
        throw "There are no folders under the Modules folder in the package at '$modulesFolderPath'. Please use the New-GuestConfigurationPackage cmdlet to generate your package. If you wish to include custom native resources in the package, please copy the compiled files into the 'Modules/DscNativeResources/<resource_name>/' folder in the package manually. Example: <package_root>/Modules/DscNativeResources/MyNativeResource/libMyNativeResource.so AND <package_root>/Modules/DscNativeResources/MyNativeResource/MyNativeResource.schema.mof"
    }

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

    if ($Apply)
    {
        $propertiesToUpdate['configurationMode'] = 'ApplyAndMonitor'
    }

    Set-GuestConfigurationPackageMetaconfigProperty -MetaconfigPath $metaconfigPath -Property $propertiesToUpdate

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
