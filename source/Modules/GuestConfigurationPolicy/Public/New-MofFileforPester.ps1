
function New-MofFileforPester
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PesterScriptsPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    Write-Verbose "Getting Pester script files from '$PesterScriptsPath'"
    $Scripts = Get-ChildItem $PesterScriptsPath -Filter "*.ps1"

    $MOFContent = ''

    # Create resource section of MOF for each script
    $index = 1
    foreach ($script in $Scripts)
    {
        $ResourceSection = $null
        $ResourceSection = New-PesterResourceSection -Name $Name -PesterFileName $script.Name -Index $index
        $index++
        $MOFContent += $ResourceSection
        $MOFContent += "`n"
    }

    # Append configuration info
    $MOFContent += @"
instance of OMI_ConfigurationDocument
{
    Version="2.0.0";
    MinimumCompatibleVersion = "1.0.0";
    CompatibleVersionAdditionalProperties= {"Omi_BaseResource:ConfigurationName"};
    Name="$Name";
};
"@

    # Write file
    Set-Content -Value $MOFContent -Path $Path -Force:$Force

    # Output the path to the new file
    [PSCustomObject]@{
        Path = $Path
    }
}
