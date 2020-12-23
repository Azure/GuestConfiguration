
Describe "MSFT_PesterResource Tests" {

    BeforeAll {
        $resourceModulePath = Join-Path -Path (Split-Path $PSScriptRoot -Path) -ChildPath "MSFT_PesterResource.psm1"
        Import-Module -Name $resourceModulePath -Force
    }

    Context 'MSFT_PesterResource\Get-ResultsfromPesterScript' {

        It 'Should return a hashtable that can be used by Get/Test' {
            InModuleScope MSFT_PesterResource {
                $function1 = Get-ResultsfromPesterScript -ScriptFilePath "$psscriptroot/TestScript.ps1"
                $function1 | Should -BeOfType 'Hashtable'
            }
        }

        It 'Should have status of False' {
            InModuleScope MSFT_PesterResource {
                $function1 = Get-ResultsfromPesterScript -ScriptFilePath "$psscriptroot/TestScript.ps1"
                $function1.status | Should -BeTrue
            }
        }

        It 'Should have Reasons' {
            InModuleScope MSFT_PesterResource {
                $function1 = Get-ResultsfromPesterScript -ScriptFilePath "$psscriptroot/TestScript.ps1"
                $function1.reasons | Should -Not -BeNullOrEmpty
            }
        }

    }

    Context "MSFT_PesterResource\Set-TargetResource" {

        It 'Should always throw' {
            { Set-TargetResource -TestFileName 'Value' } | Should -Throw
        }
    }

    Context "when the system is in the desired state\Get-TargetResource" {

        It 'Should call the function that returns information' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $true
                        reasons = @()
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName 'TestScript'
                Assert-MockCalled Get-ResultsfromPesterScript
            }
        }

        It 'Should return status as true' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $true
                        reasons = @()
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName 'TestScript'
                $get.status | Should -BeTrue
            }
        }

        It 'Should return an empty array for the property Reasons' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $true
                        reasons = @()
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName 'TestScript'
                $get.reasons | Should -Be $null
            }
        }
    }

    Context "when the system is in the desired state\Test-TargetResource" {

        It 'Should call the function that returns information' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $true
                        reasons = @()
                    } } -Verifiable
                $test = Test-TargetResource -TestFileName "TestScript"
                Assert-MockCalled Get-ResultsfromPesterScript
            }
        }

        It 'Should pass Test' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $true
                        reasons = @()
                    } } -Verifiable
                $test = Test-TargetResource -TestFileName 'TestScript'
                $test | Should -BeTrue
            }
        }
    }

    Context "when the system is not in the desired state\Get-TargetResource" {

        It 'Should call the function that returns information' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $false
                        reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName 'TestScript'
                Assert-MockCalled Get-ResultsfromPesterScript
            }
        }

        It 'Should return status as true' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $false
                        reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName 'TestScript'
                $get.status | Should -BeFalse
            }
        }

        It 'Should return a hashtable for the property Reasons' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $false
                        reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName 'TestScript'
                $get.Reasons | Should -BeOfType 'Hashtable'
            }
        }

        It 'Should have at least one reasons code' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $false
                        reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName 'TestScript'
                $get.reasons[0] | ForEach-Object Code | Should -BeOfType 'String'
                $get.reasons[0] | ForEach-Object Code | Should -Match "$script:moduleName:$script:moduleName:"
            }
        }

        It 'Should have at least one reasons phrase' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $false
                        reasons = @(@{Code = "$script:moduleName:$script:moduleName:ReasonCode"; Phrase = 'test phrase' })
                    } } -Verifiable
                $get = Get-TargetResource -TestFileName 'TestScript'
                $get.reasons | ForEach-Object Phrase | Should -BeOfType 'String'
            }
        }
    }

    Context "when the system is not in the desired state\Test-TargetResource" {

        It 'Should call the function that returns information' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $true
                        reasons = @()
                    } } -Verifiable
                $test = Test-TargetResource -TestFileName 'TestScript'
                Assert-MockCalled Get-ResultsfromPesterScript
            }
        }

        It 'Should fail Test' {
            InModuleScope MSFT_PesterResource {
                Mock Get-ResultsfromPesterScript { new-object -TypeName PSObject -Property @{
                        status  = $false
                        reasons = @()
                    } } -Verifiable
                $test = Test-TargetResource -TestFileName 'TestScript'
                $test | Should -BeFalse
            }
        }

    }
}
