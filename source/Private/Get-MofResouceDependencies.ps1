function Get-MofResouceDependencies
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]
        $MofFilePath
    )

    $platform = Get-OSPlatform

    $scriptBlock =
    {
        param
        (
            [Parameter(Mandatory = $true)]
            [string] $MofFilePathString
        )

        $mofFilePath = [System.IO.FileInfo] $MofFilePathString
        $mofFilePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($mofFilePath)

        $resourceDependencies = @()
        $reservedResourceNames = @('OMI_ConfigurationDocument')
        $mofInstances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($mofFilePath, 4)

        foreach ($mofInstance in $mofInstances)
        {
            if ($reservedResourceNames -inotcontains $mofInstance.CimClass.CimClassName -and $mofInstance.CimInstanceProperties.Name -icontains 'ModuleName')
            {
                $instanceName = ""

                if ($mofInstance.CimInstanceProperties.Name -icontains 'Name')
                {
                    $instanceName = $mofInstance.CimInstanceProperties['Name'].Value
                }

                Write-Verbose -Message "Found resource dependency in mof with instance name '$instanceName' and resource name '$($mofInstance.CimClass.CimClassName)' from module '$($mofInstance.ModuleName)' with version '$($mofInstance.ModuleVersion)'."
                $resourceDependencies += @{
                    ResourceInstanceName = $instanceName
                    ResourceName = $mofInstance.CimClass.CimClassName
                    ModuleName = $mofInstance.ModuleName
                    ModuleVersion = $mofInstance.ModuleVersion
                }
            }
        }

        Write-Verbose -Message "Found $($resourceDependencies.Count) resource dependencies in the mof."
        return $resourceDependencies
    }

    if ($platform -ieq 'Windows')
    {
        # Execute logic in the current session
        $resourceDependencies = @(& $scriptBlock $MofFilePath.FullName)
        return [Hashtable[]] $resourceDependencies
    }
    else
    {
        $workerInstallPath = Get-GCWorkerRootPath
        $binFolderDestinationPath = Join-Path -Path $workerInstallPath -ChildPath 'GC'

        # Temporarily modify LD_LIBRARY_PATH to ensure the libmi.so library can be found
        Write-Verbose -Message "Setting LD_LIBRARY_PATH to include: $binFolderDestinationPath"
        $originalLdLibraryPath = $env:LD_LIBRARY_PATH
        if ($originalLdLibraryPath)
        {
            $env:LD_LIBRARY_PATH = "$originalLdLibraryPath`:$binFolderDestinationPath"
        }
        else
        {
            $env:LD_LIBRARY_PATH = $binFolderDestinationPath
        }

        try
        {
            # Execute MOF processing in a separate PowerShell session because the ImportInstances method requires the
            # libmi.so library to be available, and LD_LIBRARY_PATH must be set before the PowerShell process starts for
            # the dynamic linker to find the library during process initialization.
            $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $MofFilePath.FullName
            $resourceDependencies = @(Receive-Job -Job $job -Wait -AutoRemoveJob)
            return [Hashtable[]] $resourceDependencies
        }
        finally
        {
            $env:LD_LIBRARY_PATH = $originalLdLibraryPath
        }
    }
}
