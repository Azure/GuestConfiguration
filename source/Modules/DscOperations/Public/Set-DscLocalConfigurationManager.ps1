
<#
    .SYNOPSIS
        Set DSC LCM settings.

    .Parameter ConfigurationName
        Configuration name.

    .Example
        Set-DscLocalConfigurationManager -Path C:\metaconfig
#>

function Set-DscLocalConfigurationManager
{
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ConfigurationName,

        [parameter(Position=1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )

    $job_id = [guid]::NewGuid().Guid
    $gcBinPath = Get-GuestConfigBinaryPath
    $dsclibPath = $(Get-DscLibPath) -replace  '[""\\]','\$&'

    if(-not ([System.Management.Automation.PSTypeName]'GuestConfig.DscOperations').Type) {
        $addTypeScript = $ExecuteDscOperationsScript -f $dsclibPath
        Add-Type -TypeDefinition $addTypeScript -ReferencedAssemblies 'System.Management.Automation','System.Console','System.Collections'
    }

    $dscOperation = [GuestConfig.DscOperations]::New()
    $result = $dscOperation.SetDscLocalConfigurationManager($PSCmdlet, $job_id, $ConfigurationName, $gcBinPath, $Path)
}
