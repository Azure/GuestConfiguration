
<#
    .SYNOPSIS
        Starting to remediate a Guest Configuration policy package.

    .Parameter Path
        Relative/Absolute local path of the zipped Guest Configuration package.

    .Parameter Parameter
        Policy parameters.

    .Parameter Force
        Allows cmdlet to make changes on machine for remediation that cannot otherwise be changed.

    .Example
        Start-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip -Force

        $Parameter = @(
            @{
                ResourceType = "MyFile"            # dsc configuration resource type (mandatory)
                ResourceId = 'hi'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Ensure"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'Present'     # dsc configuration resource property value (mandatory)
            })

        Start-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip -Parameter $Parameter -Force

    .OUTPUTS
        None.
#>

function Start-GuestConfigurationPackageRemediation
{
    [CmdletBinding()]
    [Experimental('GuestConfiguration.SetScenario', 'Show')]
    [OutputType()]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter()]
        [Switch]
        $Force,

        [Parameter()]
        [Hashtable[]]
        $Parameter = @()
    )

    $osPlatform = Get-OSPlatform

    if ($osPlatform -eq 'MacOS')
    {
        throw 'The Install-GuestConfigurationPackage cmdlet is not supported on MacOS'
    }

    $verbose = ($PSBoundParameters.ContainsKey('Verbose') -and ($PSBoundParameters['Verbose'] -eq $true))
    $systemPSModulePath = [Environment]::GetEnvironmentVariable('PSModulePath', 'Process')
    if ($PSBoundParameters.ContainsKey('Force') -and $Force)
    {
        $withForce = $true
    }
    else
    {
        $withForce = $false
    }

    try
    {
        # Install the package
        $packagePath = Install-GuestConfigurationPackage -Path $Path -Force:$withForce -ErrorAction 'Stop'

        # The leaf part of the Path returned by Install-GCPackage will always be the BaseName of the MOF.
        $packageName = Get-GuestConfigurationPackageName -Path $packagePath

        # Confirm mof exists
        $packageMof = Join-Path -Path $packagePath -ChildPath "$packageName.mof"
        $dscDocument = Get-Item -Path $packageMof -ErrorAction 'SilentlyContinue'
        if (-not $dscDocument)
        {
            throw "Invalid Guest Configuration package, failed to find dsc document at $packageMof path."
        }

        # Throw if package is not set to AuditAndSet. If metaconfig is not found, assume Audit.
        $metaConfig = Get-GuestConfigurationPackageMetaConfig -Path $packagePath
        if ($metaConfig.Type -ne "AuditAndSet")
        {
            throw "Cannot run Start-GuestConfigurationPackage on a package that is not set to AuditAndSet. Current metaconfig contents: $metaconfig"
        }

        # Update mof values
        if ($Parameter.Count -gt 0)
        {
            Write-Debug -Message "Updating MOF with $($Parameter.Count) parameters."
            Update-MofDocumentParameters -Path $dscDocument.FullName -Parameter $Parameter
        }

        Write-Verbose -Message "Publishing policy package '$packageName' from '$packagePath'."
        Publish-DscConfiguration -ConfigurationName $packageName -Path $packagePath -Verbose:$verbose

        # Set LCM settings to force load powershell module.
        $metaConfigPath = Join-Path -Path $packagePath -ChildPath "$packageName.metaconfig.json"
        Write-Debug -Message "Setting 'LCM' Debug mode to force module import."
        Update-GuestConfigurationPackageMetaconfig -metaConfigPath $metaConfigPath -Key 'debugMode' -Value 'ForceModuleImport'
        Write-Debug -Message "Setting 'LCM' configuration mode to ApplyAndMonitor."
        Update-GuestConfigurationPackageMetaconfig -metaConfigPath $metaConfigPath -Key 'configurationMode' -Value 'ApplyAndMonitor'
        Set-DscLocalConfigurationManager -ConfigurationName $packageName -Path $packagePath -Verbose:$verbose

        # Run Deploy/Remediation
        Start-DscConfiguration -ConfigurationName $packageName -Verbose:$verbose
    }
    finally
    {
        $env:PSModulePath = $systemPSModulePath
    }
}
