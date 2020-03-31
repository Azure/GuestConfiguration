######################################################
#  End to end Guest Configuration module reporting test
#  Verify report is sent for every consistency run of a 
#  configuration assignement.
######################################################

$ErrorActionPreference = 'Stop'

function Get-OSPlatform {
    [OutputType([String])]
    [CmdletBinding()]
    param()

    $platform = 'Windows'

    if ($PSVersionTable.PSEdition -eq 'Desktop') {
        $platform = 'Windows'
    }
    elseif ($PSVersionTable.PSEdition -eq 'Core') {
        if ($IsWindows) {
            $platform = 'Windows'
        }
        elseif ($IsLinux) {
            $platform = 'Linux'
        }
        elseif ($IsMacOS) {
            $platform = 'MacOS'
        }
    }

    return $platform
}

function Test-CurrentMachineIsWindows {
    [OutputType([Boolean])]
    [CmdletBinding()]
    param ()

    $currentOSPlatform = Get-OSPlatform
    $currentMachineIsWindows = $currentOSPlatform -ieq 'Windows'
    return $currentMachineIsWindows
}

function New-TestCertificate {
    [CmdletBinding()]
    param ()

    # Create self signed certificate
    $certificatePath = "Cert:\LocalMachine\My"
    $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
    if ($null -eq $certificate) {
        $selfSignedCertModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'New-SelfSignedCertificateEx.ps1'
        Import-Module -Name $selfSignedCertModulePath -Force 
        $null = New-SelfsignedCertificateEx `
            -Subject "CN=testcert" `
            -EKU 'Code Signing' `
            -KeyUsage 'KeyEncipherment, DataEncipherment, DigitalSignature' `
            -SAN $env:ComputerName `
            -FriendlyName 'DSC Credential Encryption certificate' `
            -Exportable `
            -StoreLocation 'LocalMachine' `
            -KeyLength 2048 `
            -ProviderName 'Microsoft Enhanced Cryptographic Provider v1.0' `
            -AlgorithmName 'RSA' `
            -SignatureAlgorithm 'SHA256'
    }

    $command = @'
$Cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { ($_.Subject -eq 'CN=testcert') } | Select-Object -First 1
Export-Certificate -FilePath "$TestDrive/exported.cer" -Cert $Cert
Import-Certificate -FilePath "$TestDrive/exported.cer" -CertStoreLocation Cert:\LocalMachine\Root
'@                
    powershell.exe -NoProfile -NonInteractive -Command $command
}

function New-TestDscConfiguration {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $DestinationFolderPath
    )

    if ($false -eq (Test-CurrentMachineIsWindows)) {
        Import-Module 'PSDesiredStateConfiguration'
    }

    # Set up the DSC configuration
    $dscConfig = @"
Configuration DSCConfig
{
    Import-DSCResource -ModuleName ComputerManagementDsc

    Node 'localhost'
    {
        TimeZone TimeZoneExample
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Tonga Standard Time'
        }
    }
}
DSCConfig -OutputPath $DestinationFolderPath
"@

    $destinationScriptPath = Join-Path -Path $TestDrive -ChildPath 'DSCConfig.ps1'

    $null = Set-Content -Path $destinationScriptPath -Value $dscConfig
    & $destinationScriptPath
}

function Initialize-MachineForGCTesting {
    [CmdletBinding()]
    param ()

    Write-Verbose -Message 'Setting up Azure DevOps machine for Guest Configuration module testing...' -Verbose

    # Make sure traffic is using TLS 1.2 as all Azure services reject connections below 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    if (Test-CurrentMachineIsWindows) {
        Set-ExecutionPolicy -ExecutionPolicy 'Bypass' -Scope 'Process'
    }

    Install-Module -Name 'ComputerManagementDsc' -AllowClobber -Force
    
    $gcModuleFolderPath = Split-Path -Path $PSScriptRoot -Parent
    if (Test-CurrentMachineIsWindows) {
        $delimiter = ";"
    }
    else {
        $delimiter = ":"
    }
    $Env:PSModulePath = "$gcModuleFolderPath" + "$delimiter" + "$Env:PSModulePath"

    $gcModulePath = Join-Path $gcModuleFolderPath 'GuestConfiguration.psd1'
    Import-Module $gcModulePath
    Write-ModuleInfo -ModuleName 'GuestConfiguration'

    if ('true' -eq $Env:RELEASEBUILD) {
        Install-AzLibraries
        Login-ToTestAzAccount
    }
}

function Write-ModuleInfo {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ModuleName
    )

    $titleLine = "$($ModuleName.ToUpper()) MODULE INFO"
    
    Write-Verbose -Message "`n$titleLine`n$('-' * $titleLine.length)" -Verbose
    $moduleInfo = Get-Module -Name $ModuleName
    if ($null -ne $moduleInfo) {
        Write-Verbose -Message "$($moduleInfo | Format-List | Out-String)" -Verbose
    }
    else {
        Write-Verbose -Message "Module '$ModuleName' not loaded" -Verbose
    }
}

function Write-EnvironmentVariableInfo {
    [CmdletBinding()]
    param ()

    $titleLine = "ENVIRONMENT VARIABLE INFO"
    Write-Verbose -Message "`n$titleLine`n$('-' * $titleLine.length)" -Verbose

    $envVars = Get-ChildItem -Path "env:*"
    Write-Verbose -Message "$($envVars | sort-object name | Out-String)" -Verbose
}

function Write-EnvironmentInfo {
    [CmdletBinding()]
    param ()

    $psTitleLine = "POWERSHELL INFO"
    Write-Verbose -Message "`n$psTitleLine`n$('-' * $psTitleLine.length) $($PSVersionTable | Format-List | Out-String)"  -Verbose
    Write-ModuleInfo -ModuleName 'Pester'
    Write-EnvironmentVariableInfo
}

Describe 'Test Guest Configuration Custom Policy cmdlets' {
    BeforeAll {
        if ('true' -eq $Env:RELEASEBUILD) {
            # Import the AzHelper module
            $gcModuleFolderPath = Split-Path -Path $PSScriptRoot -Parent
            $helperModulesFolderPath = Join-Path -Path $gcModuleFolderPath -ChildPath 'helpers'
            $azHelperModulePath = Join-Path -Path $helperModulesFolderPath -ChildPath 'AzHelper.psm1'
            Write-Verbose -Message "Importing AzHelper module..." -Verbose
            Import-Module -Name $azHelperModulePath

            # Initialize the machine if needed
            if (Test-CurrentMachineIsWindows) {
                if (Test-ServicePrincipalAccountInEnviroment) {
                    Initialize-MachineForGCTesting
                }
                else {
                    Write-Verbose -Message "Current machine does not have a service principal available. Test environment should have been set up manually. Please ensure you are logged in to an Azure account and the GuestConfiguration and ComputerManagementDsc modules are installed." -Verbose
                }
            }
            else {
                throw 'Current machine is not running Windows. The Guest Configuration module is currently only supported on Windows.'
            }
        }

        if ($null -eq $Env:RELEASEBUILD -OR 'false' -eq $Env:RELEASEBUILD) {
            Initialize-MachineForGCTesting
        }

        Write-EnvironmentInfo

        # Set up test paths
        $dscConfigFolderPath = Join-Path -Path $TestDrive -ChildPath 'DSCConfig'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
    
        New-TestDscConfiguration -DestinationFolderPath $dscConfigFolderPath
        if (Test-CurrentMachineIsWindows) {
            New-TestCertificate
        }

        # Set up type needed for package extraction
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
    }

    Context 'Guest Configuration policy packages' {
        $policyName = 'testPolicy'
        $mofDocPath = Join-Path -Path $dscConfigFolderPath -ChildPath 'localhost.mof'
        $testPackagePath = Join-Path -Path $testOutputPath -ChildPath 'package'
        $package = New-GuestConfigurationPackage -Configuration $mofDocPath -Name $policyName -Path $testPackagePath

        $unsignedPackageExtractionPath = Join-Path $testOutputPath -ChildPath 'UnsignedPackage'
        $signedPackageExtractionPath = Join-Path $testOutputPath -ChildPath 'SignedPackage'

        It 'Verify package exists after creation' {
            Test-Path -Path $package.Path | Should Be $true
        }
        
        It 'Verify package name after creation' {
            $package.Name | Should Be $policyName
        }

        It 'Verify the package can be extracted' {
            { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $unsignedPackageExtractionPath) } | Should Not Throw
        }
  
        $mofFilePath = Join-Path -Path $unsignedPackageExtractionPath -ChildPath "$policyName.mof"

        It 'Verify extracted mof document exists' {
            Test-Path -Path $mofFilePath | Should Be $true
        }

        It 'Verify all required modules are included in the package' {
            $extractedModulesPath = Join-Path -Path $unsignedPackageExtractionPath -ChildPath 'Modules'
            $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($mofFilePath, 4) 
            for ($numResources = 0; $numResources -lt $resourcesInMofDocument.Count; $numResources++) {
                if ($resourcesInMofDocument[$numResources].CimInstanceProperties.Name -contains 'ModuleName') {
                    $resourceModuleName = $resourcesInMofDocument[$numResources].ModuleName
                    $resourceModulePath = Join-Path -Path $extractedModulesPath -ChildPath $resourceModuleName
                    Test-Path -Path $resourceModulePath | Should Be $true
                }
            }
        }

        if (Test-CurrentMachineIsWindows) {
            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path

            It 'Validate overall compliance status' {
                $testPackageResult.complianceStatus | Should Be $false
            }

            It 'Validate that the resource compliance results are as expected' {
                $testPackageResult.resources[0].ModuleName | Should Be 'ComputerManagementDsc'
                $testPackageResult.resources[0].complianceStatus | Should Be $false
                $testPackageResult.resources[0].ConfigurationName | Should Be 'DSCConfig'
                $testPackageResult.resources[0].IsSingleInstance | Should Be 'Yes'
            }

            $certificatePath = "Cert:\LocalMachine\My"
            $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
            $protectPackageResult = Protect-GuestConfigurationPackage -Path $package.Path -Certificate $certificate 
        
            It 'Signed package should exist at output path' {
                Test-Path -Path $protectPackageResult.Path | Should Be $true
            }
    
            It 'Package should be extractable' {
                { [System.IO.Compression.ZipFile]::ExtractToDirectory($protectPackageResult.Path, $signedPackageExtractionPath) } | Should Not Throw
            }

            $catFileName = "$policyName.cat"
            $catFilePath = Join-Path -Path $signedPackageExtractionPath -ChildPath $catFileName
        
            It '.cat file should exist in the extracted package' {
                Test-Path -Path $catFilePath | Should Be $true
            }

            It 'Extracted .cat file thumbprint should match certificate thumbprint' {
                $authenticodeSignature = Get-AuthenticodeSignature -FilePath $catFilePath
                $authenticodeSignature.SignerCertificate.Thumbprint | Should Be $certificate.Thumbprint
            }
        }
    }

    if ('true' -eq $Env:RELEASEBUILD) {
        Context 'Guest Configuration policy definitions' {
            $testPolicyName = 'AuditWindowsService'
            $currentDateString = Get-Date -Format "yyyy-MM-dd HH:mm"
            if (Test-CurrentMachineIsWindows) {
                $computerInfo = Get-ComputerInfo
                $currentWindowsOSString = $computerInfo.WindowsProductName
            }
            else {
                $currentWindowsOSString = 'Non-Windows'
            }
            $expectedPolicyType = 'Custom'
            $expectedContentHash = 'D421E3C8BB2298AEC5CFD95607B91241B7D5A2C88D54262ED304CA1FD01370F3'

            $newGCPolicyParameters = @{
                ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
                DisplayName = "[Test] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
                Description = 'Policy to audit a Windows service'
                Path        = Join-Path -Path $testOutputPath -ChildPath 'policyDefinitions'
                Version     = '1.0.0.0'
            }

            $newGCPolicyResult = New-GuestConfigurationPolicy @newGCPolicyParameters

            It 'New-GuestConfigurationPolicy should output path to generated policies' {
                $newGCPolicyResult.Path | Should Not BeNullOrEmpty
            }

            It 'Generated definition output path should exist' {
                Test-Path -Path $newGCPolicyResult.Path | Should Be $true
            }

            $auditPolicyFile = Join-Path -Path $newGCPolicyResult.Path -ChildPath 'AuditIfNotExists.json'

            It 'Generated Audit policy file should exist' {
                Test-Path -Path $auditPolicyFile | Should Be $true
            }

            $auditPolicyContent = Get-Content $auditPolicyFile | ConvertFrom-Json | ForEach-Object { $_ }

            It 'Audit policy should contain expected content' {
                $auditPolicyContent.properties.displayName.Contains($newGCPolicyParameters.DisplayName) | Should Be $true
                $auditPolicyContent.properties.description.Contains($newGCPolicyParameters.Description) | Should Be $true
                $auditPolicyContent.properties.policyType | Should Be $expectedPolicyType
                $auditPolicyContent.properties.policyRule.then.details.name | Should Be $testPolicyName
            }

            $deployPolicyFile = Join-Path -Path $newGCPolicyResult.Path -ChildPath 'DeployIfNotExists.json'

            It 'Generated Deploy policy file should exist' {
                Test-Path -Path $deployPolicyFile | Should Be $true
            }

            $deployPolicyContent = Get-Content $deployPolicyFile | ConvertFrom-Json | ForEach-Object { $_ }

            It 'Deploy policy should contain expected content' {
                $deployPolicyContent.properties.displayName.Contains($newGCPolicyParameters.DisplayName) | Should Be $true
                $deployPolicyContent.properties.description.Contains($newGCPolicyParameters.Description) | Should Be $true
                $deployPolicyContent.properties.policyType | Should Be $expectedPolicyType
                $deployPolicyContent.properties.policyRule.then.details.deployment.properties.parameters.configurationName.value | Should Be $testPolicyName
                $deployPolicyContent.properties.policyRule.then.details.deployment.properties.parameters.contentHash.value | Should Be $expectedContentHash
                $deployPolicyContent.properties.policyRule.then.details.deployment.properties.parameters.contentUri.value | Should Be $newGCPolicyParameters.ContentUri
            }

            $publishGCPolicyResult = $newGCPolicyResult | Publish-GuestConfigurationPolicy

            $existingPolicies = @(Get-AzPolicyDefinition | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName.Contains($newGCPolicyParameters.DisplayName)) })
            It 'Should be able to retrieve 2 published policies' {
                $null -ne $existingPolicies | Should Be $true
                $existingPolicies.Count | Should Be 2
            }

            $existingInitiatives = @(Get-AzPolicySetDefinition | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName.Contains($newGCPolicyParameters.DisplayName)) })
            It 'Should be able to retrieve 1 published initiative' {
                $null -ne $existingInitiatives | Should Be $true
                $existingInitiatives.Count | Should Be 1
            }
        

            # Cleanup
            foreach ($existingInitiative in $existingInitiatives) {
                $null = Remove-AzPolicySetDefinition -Name $existingInitiative.Name -Force
            }

            foreach ($existingPolicy in $existingPolicies) {
                $null = Remove-AzPolicyDefinition -Name $existingPolicy.Name -Force
            }
        }
    }
}
