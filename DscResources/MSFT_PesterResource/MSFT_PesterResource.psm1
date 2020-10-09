<#
    .SYNOPSIS
        Run Pester tests and return results as reasons
    .DESCRIPTION
        This module will run tests stored in folder
        'Scripts' at the root of the module.
        This is a proof of concept to validate
        running Pester from Guest Configuration
        policies.
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

    $Return = Get-ResultsfromPesterScript -ScriptFilePath "$PSScriptRoot/../../Scripts/$TestFileName.ps1"

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