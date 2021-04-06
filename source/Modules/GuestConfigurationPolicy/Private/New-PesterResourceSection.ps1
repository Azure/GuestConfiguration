
function New-PesterResourceSection
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [String]
        $PesterFileName,

        [Parameter()]
        [String]
        $index = 1
    )

    $Version = (Get-Module -Name 'GuestConfiguration').Version.ToString()

    # this is a workaround for inserting the variable in the middle of a word inside a here-string
    $ref = '$MSFT_PesterResource'+$Index+'ref'

    # MOF should not contain the file extension since that is added by the resource
    $PesterFileName = $PesterFileName.replace('.ps1','')

    $MOFResourceSection = @"
instance of MSFT_PesterResource as $ref
{
    ModuleName = "GuestConfiguration";
    SourceInfo = "Pester scripts";
    PesterFileName = "$PesterFileName";
    ResourceID = "[PesterResource]$PesterFileName";
    ModuleVersion = "$Version";
    ConfigurationName = "$Name";
};
"@

    return $MOFResourceSection
}
