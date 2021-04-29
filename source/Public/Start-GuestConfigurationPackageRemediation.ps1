
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
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
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

    if (-not (Test-Path -Path $Path -PathType Leaf))
    {
        throw 'Invalid Guest Configuration package path : $($Path)'
    }

    $verbose = ($PSBoundParameters.ContainsKey('Verbose') -and ($PSBoundParameters['Verbose'] -eq $true))
    $systemPSModulePath = [Environment]::GetEnvironmentVariable('PSModulePath', 'Process')

    try
    {
        # Install the package
        Install-GuestConfigurationPackage -Path $Path

        # Confirm mof exists
        $policyPath = Join-Path -Path $(Get-GuestConfigPolicyPath) -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($Path))
        $dscDocument = Get-ChildItem -Path $policyPath -Filter *.mof
        if (-not $dscDocument)
        {
            throw "Invalid policy package, failed to find dsc document in policy package."
        }

        # Throw if package is not set to AuditAndSet. If metaconfig is not found, assume Audit.
        $policyName = [System.IO.Path]::GetFileNameWithoutExtension($dscDocument)
        $metaConfigFile = Get-ChildItem -Path $policyPath -Filter "$policyName.metaconfig.json"
        $metaConfig = Get-Content -Raw -Path $metaConfigFile | ConvertFrom-Json
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

        # Set LCM settings to force load powershell module.
        $metaConfigPath = Join-Path -Path $policyPath -ChildPath "$policyName.metaconfig.json"
        Write-Debug -Message "Setting 'LCM' Debug mode to force module import."
        Update-GuestConfigurationPackageMetaconfig -metaConfigPath $metaConfigPath -Key 'debugMode' -Value 'ForceModuleImport'
        Write-Debug -Message "Setting 'LCM' configuratoin mode to ApplyAndMonitor."
        Update-GuestConfigurationPackageMetaconfig -metaConfigPath $metaConfigPath -Key 'configurationMode' -Value 'ApplyAndMonitor'
        Set-DscLocalConfigurationManager -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        # Run Deploy/Remediation
        Start-DscConfiguration -ConfigurationName $policyName -Verbose:$verbose

    }
    finally
    {
        $env:PSModulePath = $systemPSModulePath
    }
}
