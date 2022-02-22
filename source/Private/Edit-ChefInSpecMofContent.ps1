
function Edit-ChefInSpecMofContent
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PackageName,

        [Parameter(Mandatory = $true)]
        [String]
        $MofPath
    )

    Write-Verbose -Message "Editing the mof at '$MofPath' to update native InSpec resource parameters"

    $mofInstances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($MofPath, 4)

    foreach ($mofInstance in $mofInstances)
    {
        $resourceClassName = $mofInstance.CimClass.CimClassName

        if ($resourceClassName -ieq 'MSFT_ChefInSpecResource')
        {
            $profilePath = "$PackageName/Modules/$($mofInstance.Name)/"

            $gitHubPath = $mofInstance.CimInstanceProperties.Item('GithubPath')
            if ($null -eq $gitHubPath)
            {
                $gitHubPath = [Microsoft.Management.Infrastructure.CimProperty]::Create('GithubPath', $profilePath, [Microsoft.Management.Infrastructure.CimFlags]::Property)
                $mofInstance.CimInstanceProperties.Add($gitHubPath)
            }
            else
            {
                $gitHubPath.Value = $profilePath
            }
        }
    }

    Write-MofContent -MofInstances $mofInstances -OutputPath $MofPath
}
