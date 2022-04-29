function Get-ResouceDependenciesFromMof
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]
        $MofFilePath
    )

    $MofFilePath = Resolve-RelativePath -Path $MofFilePath

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
