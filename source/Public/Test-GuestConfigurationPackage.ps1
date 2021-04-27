
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
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter()]
        [Hashtable[]]
        $Parameter = @()
    )

    if ($env:OS -notmatch "Windows" -and $IsMacOS)
    {
        throw 'The Test-GuestConfigurationPackage cmdlet is not supported on MacOS'
    }

    if (-not (Test-Path $Path -PathType Leaf))
    {
        throw 'Invalid Guest Configuration package path : $($Path)'
    }

    $verbose = $PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true)
    $systemPSModulePath = [Environment]::GetEnvironmentVariable("PSModulePath", "Process")

    try
    {
        # Create policy folder
        $Path = Resolve-Path -Path $Path
        $policyPath = Join-Path $(Get-GuestConfigPolicyPath) ([System.IO.Path]::GetFileNameWithoutExtension($Path))
        Remove-Item $policyPath -Recurse -Force -ErrorAction SilentlyContinue
        $null = New-Item -ItemType Directory -Force -Path $policyPath

        Write-Verbose -Message "Unzipping the policy package to '$($policyPath)'."
        Expand-Archive -LiteralPath $Path $policyPath -Force -ErrorAction Stop

        # Get policy name
        Write-Debug -Message "Getting the policy name from the MOF:"
        $dscDocument = Get-ChildItem -Path $policyPath -Filter *.mof
        if (-not $dscDocument)
        {
            throw "Invalid policy package, failed to find dsc document in policy package."
        }

        $policyName = [System.IO.Path]::GetFileNameWithoutExtension($dscDocument)
        Write-Debug -Message "PolicyName: '$policyName'."

        # update configuration parameters
        if ($Parameter.Count -gt 0)
        {
            Write-Debug -Message "Updating MOF with $($Parameter.Count) parameters."
            Update-MofDocumentParameters -Path $dscDocument.FullName -Parameter $Parameter
        }

        # Unzip Guest Configuration binaries
        $gcBinPath = Get-GuestConfigBinaryPath
        $gcBinRootPath = Get-GuestConfigBinaryRootPath
        if (-not (Test-Path -Path $gcBinPath))
        {
            Write-Debug -Message "Installing the Guest Config binaries..."
            # Clean the bin folder
            Remove-Item -Path $gcBinRootPath'\*' -Recurse -Force -ErrorAction SilentlyContinue

            $zippedBinaryPath = Join-Path -Path $(Get-GuestConfigurationModulePath) -ChildPath 'bin'
            if ($(Get-OSPlatform) -eq 'Windows')
            {
                $zippedBinaryPath = Join-Path -Path $zippedBinaryPath -ChildPath 'DSC_Windows.zip'
            }
            else
            {
                # Linux zip package contains an additional DSC folder
                # Remove DSC folder from binary path to avoid two nested DSC folders.
                $null = New-Item -ItemType Directory -Force -Path $gcBinPath
                $gcBinPath = (Get-Item -Path $gcBinPath).Parent.FullName
                $zippedBinaryPath = Join-Path $zippedBinaryPath 'DSC_Linux.zip'
            }

            Write-Debug -Message "Extracting '$zippedBinaryPath' to '$gcBinPath'."
            [System.IO.Compression.ZipFile]::ExtractToDirectory($zippedBinaryPath, $gcBinPath)
        }


        Write-Verbose -Message "Publishing policy package '$policyName' from '$policyPath'."
        Publish-DscConfiguration -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        # Set LCM settings to force load powershell module.
        Write-Debug -Message "Setting 'LCM' Debug mode to force module import."
        $metaConfigPath = Join-Path -Path $PackagePath -ChildPath "$packageName.metaconfig.json"
        # If metaconfig already exists, append
        if (Test-Path $metaConfigPath)
        {
            $metaConfigObject = Get-Content -Path $metaConfigPath | ConvertFrom-Json -AsHashTable
            $metaConfigObject["debugMode"] = "ForceModuleImport"
            $metaConfigObject | ConvertTo-Json | Out-File $metaConfigPath -Encoding ascii -Force
        }
        else
        {
            "{""debugMode"":""ForceModuleImport""}" | Out-File $metaConfigPath -Encoding ascii
        }
        Set-DscLocalConfigurationManager -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        $inspecProfilePath = Get-InspecProfilePath
        Write-Debug -Message "Clearing Inspec profiles at '$inspecProfilePath'."
        Remove-Item -Path $inspecProfilePath -Recurse -Force -ErrorAction SilentlyContinue

        Write-Verbose -Message "Testing ConfigurationName '$policyName'."
        $testResult = Test-DscConfiguration -ConfigurationName $policyName -Verbose:$verbose
        Write-Verbose -Message "Getting Configuration resources status."
        $getResult = @()
        $getResult = $getResult + (Get-DscConfiguration -ConfigurationName $policyName -Verbose:$verbose)

        Write-Debug -Message "Processing Resources not in Desired state."
        $testResult.resources_not_in_desired_state | ForEach-Object {
            $resourceId = $_;
            if ($getResult.count -gt 1)
            {
                for ($i = 0; $i -lt $getResult.Count; $i++)
                {
                    if ($getResult[$i].ResourceId -ieq $resourceId)
                    {
                        $getResult[$i] = $getResult[$i] | Select-Object *, @{
                            n = 'complianceStatus'
                            e = { $false }
                        }
                    }
                }
            }
            elseif ($getResult.ResourceId -ieq $resourceId)
            {
                $getResult = $getResult | Select-Object *, @{
                    n = 'complianceStatus'
                    e = { $false }
                }
            }
        }

        $testResult.resources_in_desired_state | ForEach-Object {
            $resourceId = $_
            if ($getResult.count -gt 1)
            {
                for ($i = 0; $i -lt $getResult.Count; $i++)
                {
                    if ($getResult[$i].ResourceId -ieq $resourceId)
                    {
                        $getResult[$i] = $getResult[$i] | Select-Object *, @{
                            n = 'complianceStatus'
                            e = { $true }
                        }
                    }
                }
            }
            elseif ($getResult.ResourceId -ieq $resourceId)
            {
                $getResult = $getResult | Select-Object *, @{
                    n = 'complianceStatus'
                    e = { $true }
                }
            }
        }

        [PSCustomObject]@{
            complianceStatus = $testResult.compliance_state
            resources        = $getResult
        }
    }
    finally
    {
        $env:PSModulePath = $systemPSModulePath
    }
}
