
<#
    .SYNOPSIS
        Tests a Guest Configuration policy package.

    .Parameter Path
        Full path of the zipped Guest Configuration package.

    .Parameter Parameter
        Policy parameters.

    .Example
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
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter()]
        [Hashtable[]]
        $Parameter = @(),

        [Parameter()]
        [Switch]
        $Force
    )

    if ($IsMacOS)
    {
        throw 'The Test-GuestConfigurationPackage cmdlet is not supported on MacOS'
    }

    # Determine if verbose is enabled to pass down to other functions
    $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
    $systemPSModulePath = [Environment]::GetEnvironmentVariable("PSModulePath", "Process")
    $gcBinPath = Get-GuestConfigBinaryPath
    $guestConfigurationPolicyPath = Get-GuestConfigPolicyPath
    if ($PSBoundParameters.ContainsKey('Force') -and $PSBoundParameters['Force'])
    {
        $withForce = $true
    }
    else
    {
        $withForce = $false
    }

    try
    {
        # Get the installed policy path, and install if missing
        $packagePath = Install-GuestConfigurationPackage -Path $Path -Verbose:$verbose -Force:$withForce


        $packageName = Get-GuestConfigurationPackageName -Path $packagePath
        Write-Debug -Message "PackageName: '$packageName'."
        # Confirm mof exists
        $packageMof = Join-Path -Path $packagePath -ChildPath "$packageName.mof"
        $dscDocument = Get-Item -Path $packageMof -ErrorAction 'SilentlyContinue'
        if (-not $dscDocument)
        {
            throw "Invalid Guest Configuration package, failed to find dsc document at '$packageMof' path."
        }

        # update configuration parameters
        if ($Parameter.Count -gt 0)
        {
            Write-Debug -Message "Updating MOF with $($Parameter.Count) parameters."
            Update-MofDocumentParameters -Path $dscDocument.FullName -Parameter $Parameter
        }

        Write-Verbose -Message "Publishing policy package '$packageName' from '$packagePath'."
        Publish-DscConfiguration -ConfigurationName $packageName -Path $packagePath -Verbose:$verbose

        # Set LCM settings to force load powershell module.
        Write-Debug -Message "Setting 'LCM' Debug mode to force module import."
        $metaConfigPath = Join-Path -Path $packagePath -ChildPath "$packageName.metaconfig.json"
        Update-GuestConfigurationPackageMetaconfig -metaConfigPath $metaConfigPath -Key 'debugMode' -Value 'ForceModuleImport'
        Set-DscLocalConfigurationManager -ConfigurationName $packageName -Path $packagePath -Verbose:$verbose

        $inspecProfilePath = Get-InspecProfilePath
        Write-Debug -Message "Clearing Inspec profiles at '$inspecProfilePath'."
        Remove-Item -Path $inspecProfilePath -Recurse -Force -ErrorAction SilentlyContinue

        Write-Verbose -Message "Getting Configuration resources status."
        $getResult = @()
        $getResult = $getResult + (Get-DscConfiguration -ConfigurationName $packageName -Verbose:$verbose)
        return $getResult
    }
    finally
    {
        $env:PSModulePath = $systemPSModulePath
    }
}
