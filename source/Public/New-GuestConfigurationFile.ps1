
<#
    .SYNOPSIS
        Automatically generate a MOF file based on
        files discovered in a folder path

        This command is optional and is intended to
        reduce the number of steps needed when
        using other language abstractions such as Pester

        When creating packages from compiled DSC
        configurations, you do not need to run this command

    .Parameter Source
        Location of the folder containing content

    .Parameter Path
        Location of the folder containing content

    .Parameter Format
        Format of the files (currently only Pester is supported)

    .Parameter Force
        When specified, will overwrite the destination file if it already exists

    .Example
        New-GuestConfigurationFile -Path ./Scripts

    .OUTPUTS
        Return the path of the generated configuration MOF file
#>

function New-GuestConfigurationFile
{
    [CmdletBinding()]
    [Experimental("GuestConfiguration.Pester", "Show")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(Position = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Source,

        [Parameter(Position = 2, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter(Position = 3, ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Format = 'Pester',

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    $return = [PSCustomObject]@{
        Name = ''
        Configuration = ''
    }

    if ('Pester' -eq $Format)
    {
        Write-Warning -Message 'Guest Configuration: Pester content is an expiremental feature and not officially supported'
        if ([ExperimentalFeature]::IsEnabled("GuestConfiguration.Pester"))
        {
            $ConfigMOF = New-MofFileforPester -Name $Name -PesterScriptsPath $Source -Path $Path -Force:$Force
            $return.Name = $Name
            $return.Configuration = $ConfigMOF.Path
        }
        else
        {
            throw 'Before you can use Pester content, you must enable the experimental feature in PowerShell.'
        }
    }

    return $return
}
