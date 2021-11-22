function Copy-DscResources
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $MofDocumentPath,

        [Parameter(Mandatory = $true)]
        [String]
        $Destination,

        [Parameter()]
        [Switch]
        $Force
    )

    Write-Verbose -Message 'Copying DSC resource modules required by the given configuration...'

    $modulesFolderPath = Join-Path -Path $Destination -ChildPath 'Modules'
    Write-Verbose -Message "Creating the package Modules folder at the path '$modulesFolderPath'"
    $null = New-Item -Path $modulesFolderPath -ItemType 'Directory' -Force

    Write-Verbose -Message "Retrieving resource dependencies from the mof file..."
    $resourceDependencies = @(Get-ResouceDependenciesFromMof -MofFilePath $MofDocumentPath)
    Write-Verbose -Message "Found $($resourceDependencies.Count) resource dependencies from the mof file."

    # Copy resource dependencies into the Modules folder
    foreach ($resourceDependency in $resourceDependencies)
    {
        if ($resourceDependency['ModuleName'] -ieq 'PSDesiredStateConfiguration')
        {
            throw "Found a dependency on the resources in the PSDesiredStateConfiguration module. Please"
        }

        if ($resourceDependency['ResourceName'] -ieq 'MSFT_ChefInspecResource')
        {
            # Attempt to find the resource dependency from a native resource
            $dependencyFound = Copy-NativeResourceDependencyToGuestConfigurationPolicyPackage -PolicyPackagePath $policyPackagePath -NativeResourceName $resourceDependency['ResourceName']

            if ($null -eq $FoldersToInclude -or $FoldersToInclude.Count -lt 1)
            {
                Write-Warning -Message "The MSFT_ChefInSpecResource resource is required but no InSpec control folder was included in the package. Please include the control folder via the FoldersToInclude parameter."
                $dependencyFound = $false
            }
        }
        else
        {
            $dependencyFound = Copy-ModuleDependencyToGuestConfigurationPolicyPackage -PolicyPackagePath $Destination -ModuleName $resourceDependency['ModuleName'] -RequiredModuleVersion $resourceDependency['ModuleVersion']
        }

        if (-not $dependencyFound)
        {
            throw "Failed to find a module or native resource to satisfy the resource dependency with resource name '$($resourceDependency['ResourceName'])', module name '$($resourceDependency['ModuleName'])', and module version '$($resourceDependency['ModuleVersion'])'."
        }
    }
}

function Get-ResouceDependenciesFromMof
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $MofFilePath
    )

    $resourceDependencies = @()
    $reservedResourceNames = @('OMI_ConfigurationDocument')
    $mofInstances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($mofFilePath, 4)

    foreach ($mofInstance in $mofInstances)
    {
        if ($reservedResourceNames -inotcontains $mofInstance.CimClass.CimClassName -and $mofInstance.CimInstanceProperties.Name -icontains 'ModuleName')
        {
            Write-Verbose -Message "Found resource dependency in mof with name '$($mofInstance.CimClass.CimClassName)' from module '$($mofInstance.ModuleName)' with version '$($mofInstance.ModuleVersion)'."
            $resourceDependencies += @{
                ResourceName = $mofInstance.CimClass.CimClassName
                ModuleName = $mofInstance.ModuleName
                ModuleVersion = $mofInstance.ModuleVersion
            }
        }
    }

    return $resourceDependencies
}

<#
    .SYNOPSIS
        Copies the module with the specified name and version from the module source path or PSModulePath to the policy package at the specified path.
    .PARAMETER PolicyPackagePath
        The path of the policy package to which to add the module.
    .PARAMETER ModuleName
        The name of the module to add to the policy package.
    .PARAMETER ModuleVersion
        The version of the module to add to the policy package.
        Specifies a minimum acceptable version of the module.
    .PARAMETER RequiredModuleVersion
        The version of the module to add to the policy package.
        Specifies an exact, required version of the module.
    .EXAMPLE
        Copy-ModuleDependencyToGuestConfigurationPolicyPackage -PolicyPackagePath $policyPackagePath -ModuleName 'PSDscResources' -RequiredModuleVersion '2.6.0.0'
#>
function Copy-ModuleDependencyToGuestConfigurationPolicyPackage
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PolicyPackagePath,

        [Parameter(Mandatory = $true)]
        [String]
        $ModuleName,

        [Parameter()]
        [String]
        $ModuleVersion
    )

    if ($ModuleName -ieq 'PSDesiredStateConfiguration')
    {
        throw 'Cannot copy resources from the PSDesiredStateConfiguration module. Please use PSDscResources in your configurations for Guest Configuraiton instead.'
    }

    $moduleCopied = $false
    $dependenciesCopied = $true

    $modulesFolderPath = Join-Path -Path $PolicyPackagePath -ChildPath 'Modules'

    $getModuleParameters = @{
        ListAvailable = $true
    }

    if ([String]::IsNullOrWhiteSpace($ModuleVersion))
    {
        Write-Verbose -Message "Searching for a module with the name '$ModuleName'..."
        $getModuleParameters['Name'] = $ModuleName
    }
    else
    {
        Write-Verbose -Message "Searching for a module with the name '$ModuleName' and version '$ModuleVersion'..."
        $getModuleParameters['FullyQualifiedName'] = @{
            ModuleName = $ModuleName
            ModuleVersion = $ModuleVersion
        }
    }

    $sourceModule = Get-Module @getModuleParameters

    if ($null -ne $sourceModule)
    {
        if ('Count' -in $sourceModule.PSObject.Properties.Name -and $sourceModule.Count -gt 1)
        {
            throw "Found more than one module with the name '$ModuleName'. Please provide a more specific version or remove one of these modules from your PSModulePath."
        }

        $moduleSourcePath = $sourceModule.ModuleBase

        Write-Verbose -Message "Copying the module '$ModuleName' with version '$ModuleVersion' from the path '$moduleSourcePath' into the policy package..."
        $null = Copy-Item -Path $moduleSourcePath -Destination $modulesFolderPath -Container -Recurse -Force
        $moduleCopied = $true

        # Add any modules required by this module to the package
        if ('RequiredModules' -in $sourceModule.PSObject.Properties.Name -and $null -ne $sourceModule.RequiredModules -and $sourceModule.RequiredModules.Count -gt 0)
        {
            foreach ($requiredModule in $sourceModule.RequiredModules)
            {
                Write-Verbose -Message "The module '$ModuleName' requires the module '$($requiredModule.Name)'. Attempting to copy the required module..."

                $copyModuleParameters = @{
                    PolicyPackagePath = $PolicyPackagePath
                    ModuleName = $requiredModule.Name
                    RequiredModuleVersion = $requiredModule.Version
                }

                $dependenciesCopied = $dependenciesCopied -and (Copy-ModuleDependencyToGuestConfigurationPolicyPackage @copyModuleParameters)
            }
        }

        # Add any modules marked as external module dependencies by this module to the package
        if ('ExternalModuleDependencies' -in $sourceModule.PSObject.Properties.Name -and $null -ne $sourceModule.ExternalModuleDependencies -and $sourceModule.ExternalModuleDependencies.Count -gt 0)
        {
            foreach ($externalModuleDependency in $sourceModule.ExternalModuleDependencies)
            {
                Write-Verbose -Message "The module '$ModuleName' requires the module '$externalModuleDependency'. Attempting to copy the required module..."

                $copyModuleParameters = @{
                    PolicyPackagePath = $PolicyPackagePath
                    ModuleName = $externalModuleDependency
                }

                $dependenciesCopied = $dependenciesCopied -and (Copy-ModuleDependencyToGuestConfigurationPolicyPackage @copyModuleParameters)
            }
        }
    }
    else
    {
        throw "Failed to find a module with the name '$ModuleName' and the version '$ModuleVersion'. Please check that the module is installed and available in your PSModulePath."
    }

    return $moduleCopied -and $dependenciesCopied
}
