<#
    .SYNOPSIS
        Get DSC configuration.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Get-DscConfiguration -ConfigurationName WindowsTLS
#>

function Get-DscConfiguration
{
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ConfigurationName
    )

    $job_id = [guid]::NewGuid().Guid
    $gcBinPath = Get-GuestConfigBinaryPath
    $dsclibPath = $(Get-DscLibPath) -replace  '[""\\]','\$&'

    if(-not ([System.Management.Automation.PSTypeName]'GuestConfig.DscOperations').Type) {
        $addTypeScript = $ExecuteDscOperationsScript -f $dsclibPath
        Add-Type -TypeDefinition $addTypeScript -ReferencedAssemblies 'System.Management.Automation','System.Console','System.Collections'
    }

    $dscOperation = [GuestConfig.DscOperations]::New()
    $result = $dscOperation.GettDscConfiguration($PSCmdlet, $job_id, $ConfigurationName, $gcBinPath)

    return ConvertFrom-Json $result
}
