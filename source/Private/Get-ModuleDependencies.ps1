function Get-ModuleDependencies
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ModuleName,

        [Parameter()]
        [String]
        $ModuleVersion,

        [Parameter()]
        [String]
        $ModuleSourcePath = $env:PSModulePath
    )

    $moduleDependencies = @()

    if ($ModuleName -ieq 'PSDesiredStateConfiguration')
    {
        throw "Found a dependency on resources from the PSDesiredStateConfiguration module, but we cannot copy these resources into the Guest Configuration package. Please switch these resources to using the PSDscResources module instead."
    }

    if ($ModuleName -ieq 'GuestConfiguration')
    {
        Write-Warning -Message "Found a dependency on resources from the GuestConfiguartion module. This module will not be copied into the package as it does not contain any valid DSC resources and it is too large. If you wish to include custom native resources in the package, please copy the compiled files into the 'Modules/DscNativeResources/<resource_name>/' folder in the package manually. Example: <package_root>/Modules/DscNativeResources/MyNativeResource/libMyNativeResource.so AND <package_root>/Modules/DscNativeResources/MyNativeResource/MyNativeResource.schema.mof"
        return
    }

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

    $originalPSModulePath = $env:PSModulePath

    try
    {
        $env:PSModulePath = $ModuleSourcePath
        $sourceModule = Get-Module @getModuleParameters
    }
    finally
    {
        $env:PSModulePath = $originalPSModulePath
    }

    if ($null -eq $sourceModule)
    {
        throw "Failed to find a module with the name '$ModuleName' and the version '$ModuleVersion'. Please check that the module is installed and available in your PSModulePath."
    }
    elseif ('Count' -in $sourceModule.PSObject.Properties.Name -and $sourceModule.Count -gt 1)
    {
        Write-Verbose -Message "Found $($sourceModule.Count) modules with the name '$ModuleName'..."

        $sourceModule = ($sourceModule | Sort-Object -Property 'Version' -Descending)[0]
        Write-Warning -Message "Found more than one module with the name '$ModuleName'. Using the version '$($sourceModule.Version)'."
    }

    $moduleDependency = @{
        Name = $sourceModule.Name
        Version = $sourceModule.Version
        SourcePath = $sourceModule.ModuleBase
    }

    $moduleDependencies += $moduleDependency

    # Add any modules required by this module to the package
    if ('RequiredModules' -in $sourceModule.PSObject.Properties.Name -and $null -ne $sourceModule.RequiredModules -and $sourceModule.RequiredModules.Count -gt 0)
    {
        foreach ($requiredModule in $sourceModule.RequiredModules)
        {
            Write-Verbose -Message "The module '$ModuleName' requires the module '$($requiredModule.Name)'"

            $getModuleDependenciesParameters = @{
                ModuleName = $requiredModule.Name
                ModuleVersion = $requiredModule.Version
                ModuleSourcePath = $ModuleSourcePath
            }

            $moduleDependencies += Get-ModuleDependencies @getModuleDependenciesParameters
        }
    }

    # Add any modules marked as external module dependencies by this module to the package
    if ('ExternalModuleDependencies' -in $sourceModule.PSObject.Properties.Name -and $null -ne $sourceModule.ExternalModuleDependencies -and $sourceModule.ExternalModuleDependencies.Count -gt 0)
    {
        foreach ($externalModuleDependency in $sourceModule.ExternalModuleDependencies)
        {
            Write-Verbose -Message "The module '$ModuleName' requires the module '$externalModuleDependency'"

            $getModuleDependenciesParameters = @{
                ModuleName = $requiredModule.Name
                ModuleSourcePath = $ModuleSourcePath
            }

            $moduleDependencies += Get-ModuleDependencies @getModuleDependenciesParameters
        }
    }

    return $moduleDependencies
}
