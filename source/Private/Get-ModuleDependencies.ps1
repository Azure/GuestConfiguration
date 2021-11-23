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
        $ModuleVersion
    )

    $moduleDependencies = @()

    if ($ModuleName -ieq 'PSDesiredStateConfiguration')
    {
        throw "Found a dependency on the PSDesiredStateConfiguration module, but we cannot copy these resources into the Guest Configuration package. Please switch these resources to using the PSDscResources module instead."
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

    $sourceModule = Get-Module @getModuleParameters

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
        Name = $resourceDependency['ModuleName']
        Version = $resourceDependency['ModuleVersion']
        SourcePath = $sourceModule.ModuleBase
    }

    $moduleDependencies += $moduleDependency

    # Add any modules required by this module to the package
    if ('RequiredModules' -in $sourceModule.PSObject.Properties.Name -and $null -ne $sourceModule.RequiredModules -and $sourceModule.RequiredModules.Count -gt 0)
    {
        foreach ($requiredModule in $sourceModule.RequiredModules)
        {
            Write-Verbose -Message "The module '$ModuleName' requires the module '$($requiredModule.Name)'. Attempting to copy the required module..."

            $getModuleDependenciesParameters = @{
                ModuleName = $requiredModule.Name
                ModuleVersion = $requiredModule.Version
            }

            $moduleDependencies += Get-ModuleDependencies @getModuleDependenciesParameters
        }
    }

    # Add any modules marked as external module dependencies by this module to the package
    if ('ExternalModuleDependencies' -in $sourceModule.PSObject.Properties.Name -and $null -ne $sourceModule.ExternalModuleDependencies -and $sourceModule.ExternalModuleDependencies.Count -gt 0)
    {
        foreach ($externalModuleDependency in $sourceModule.ExternalModuleDependencies)
        {
            Write-Verbose -Message "The module '$ModuleName' requires the module '$externalModuleDependency'. Attempting to copy the required module..."

            $getModuleDependenciesParameters = @{
                ModuleName = $requiredModule.Name
            }

            $moduleDependencies += Get-ModuleDependencies @getModuleDependenciesParameters
        }
    }

    return $moduleDependencies
}
