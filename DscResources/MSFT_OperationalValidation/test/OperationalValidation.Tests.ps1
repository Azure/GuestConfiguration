
Describe "OperationalValidation Tests" {

    BeforeAll {
        $resourceModulePath = Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "MSFT_OperationalValidation.psm1"
        Import-Module -Name $resourceModulePath -Force
    }

    Context "OperationalValidation\Get-ResultsfromPesterScript" {

        Context 'a simple function that gets information and formats it for Get-TargetResource' {

            It 'Should return a hashtable that can be used by Get/Test' {
                $function1 = Get-ResultsfromPesterScript -ScriptFilePath "$psscriptroot/TestScript.ps1"
                $function1 | Should -BeOfType 'Hashtable'
            }

            It 'Should have status of False' {
                $function1 = Get-ResultsfromPesterScript -ScriptFilePath "$psscriptroot/TestScript.ps1"
                $function1.status | Should -BeTrue
            }

            It 'Should have Reasons' {
                $function1 = Get-ResultsfromPesterScript -ScriptFilePath "$psscriptroot/TestScript.ps1"
                $function1.reasons | Should -Not -BeNullOrEmpty
            }
        }
    }

    Context "OperationalValidation\Set-TargetResource" {

        It 'Should always throw' {
            { Set-TargetResource -Property 'Value' } | Should -Throw
        }
    }

    Context 'when the system is in the desired state' {

        Context "OperationalValidation\Get-TargetResource" {

            It 'Should call the function that returns information' {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $true
                        reasons = @()
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                Assert-MockCalled Get-ResultsfromPesterScript
            }

            It 'Should return status as true' {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $true
                        reasons = @()
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                $get.status | Should -BeTrue
            }

            It 'Should return an empty array for the property Reasons' {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $true
                        reasons = @()
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                $get.reasons | Should -Be $null
            }
        }

        Context "OperationalValidation\Test-TargetResource" {

            It 'Should call the function that returns information' {
                $test = Test-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                Assert-MockCalled Get-ResultsfromPesterScript
            }

            It 'Should pass Test' {
                $test = Test-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                $test | Should -BeTrue
            }
        }
    }

    Context 'when the system is not in the desired state' {

        Context "OperationalValidation\Get-TargetResource" {

            It 'Should call the function that returns information' {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                    status  = $false
                    reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                } } -Verifiable
                $get = Get-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                Assert-MockCalled Get-ResultsfromPesterScript
            }

            It 'Should return status as true' {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                    status  = $false
                    reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                } } -Verifiable
                $get = Get-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                $get.status | Should -BeFalse
            }

            It 'Should return a hashtable for the property Reasons' {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                    status  = $false
                    reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                } } -Verifiable
                $get = Get-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                $get.Reasons | Should -BeOfType 'Hashtable'
            }

            It 'Should have at least one reasons code' {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                    status  = $false
                    reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                } } -Verifiable
                $get = Get-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                $get.reasons[0] | ForEach-Object Code | Should -BeOfType 'String'
                $get.reasons[0] | ForEach-Object Code | Should -Match "$script:moduleName:$script:moduleName:"
            }

            It 'Should have at least one reasons phrase' {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                    status  = $false
                    reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                } } -Verifiable
                $get = Get-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                $get.reasons | ForEach-Object Phrase | Should -BeOfType 'String'
            }
        }

        Context "OperationalValidation\Test-TargetResource" {

            It 'Should call the function that returns information' {
                $test = Test-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                Assert-MockCalled Get-ResultsfromPesterScript
            }

            It 'Should fail Test' {
                $test = Test-TargetResource -TestFileName "$psscriptroot/TestScript.ps1"
                $test | Should -BeFalse
            }

        }
    }
}
