<#
    .SYNOPSIS
        Run Pester tests and return results as reasons
    .DESCRIPTION
        This module will run tests stored in folder
        'PesterScripts' in the PowerShell Modules folder.
#>

function Get-ResultsfromPesterScript {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ScriptFilePath
    )

    Write-Verbose "[$((get-date).getdatetimeformats()[45])] About to run Pester script"

    $Pester = Invoke-Pester -Path $ScriptFilePath -PassThru

    Write-Verbose "[$((get-date).getdatetimeformats()[45])] Capturing Pester output for Policy"

    $Reasons = @()
    $Status = $true

    $DescribeBlocks = $Pester | ForEach-Object TestResult | ForEach-Object Describe | Select-Object -unique
    $ContextBlocks = $Pester | ForEach-Object TestResult | ForEach-Object Context | Select-Object -unique

    foreach ($Describe in $DescribeBlocks) {
        $testResultsInDescribe = $Pester.TestResult | Where-Object {$_.Describe -eq $Describe}
        $Phrase = "Describing $Describe`n"

        foreach ($Context in $ContextBlocks) {
            $contextInDescribe = $testResultsInDescribe | Where-Object {$_.Context -eq $Context}
            $Phrase = $Phrase+"`tContext: $Context`n"

            foreach ($testResult in $contextInDescribe) {

                if ('' -ne $testResult.FailureMessage) {
                    $Phrase = $Phrase+"`t`t[-]  $($testResult.Name)`n"
                    $Status = $false
                    $Phrase = $Phrase+"`t`t`tFailure Message: $($testResult.FailureMessage)`n"
                }
                else {
                    $Phrase = $Phrase+"`t`t[+]  $($testResult.Name)`n"
                }
            }
        }
    }

    $Reasons += @{
        Code   = 'PesterResource:PesterResource:ScriptOutput'
        Phrase = $Phrase+"`n"
    }

    $Return = @{
        TestFileName = $TestFileName
        Status  = $Status
        Reasons = $Reasons
    }

    return $Return

}

function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $TestFileName
    )

    $Return = Get-ResultsfromPesterScript -ScriptFilePath "$PSScriptRoot/../../../../Modules/PesterScripts/$TestFileName.ps1"

    return $Return
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $TestFileName
    )

    $Return = (Get-TargetResource -TestFileName $TestFileName).Status

    return $Return
}

function Set-TargetResource {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $TestFileName
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}

<#
    DSC Resource
    Class implementation holding for PWSH 7.2

class reasons
{
    [DscProperty(Mandatory)]
    [string]$code
    [DscProperty(Mandatory)]
    [string]$phrase
}

[DscResource()]
class PesterResource
{
    [DscProperty(Key)]
    [string]$TestFileName
    
    [DscProperty(NotConfigurable)]
    [reasons[]]$reasons

    [void] Set()
    {
        Set-TargetResource -path $this.TestFileName
    }

    [bool] Test()
    {
        $test = Test-TargetResource -path $this.TestFileName
        return $test
    }

    [PesterResource] Get()
    {
        $get = Get-TargetResource -path $this.TestFileName
        $this.TestFileName  = $get['TestFileName']
        $this.reasons       = $get['reasons']
        return $this
    }
}
#>