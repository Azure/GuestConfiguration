
[DscResource()]
class MSFT_ChefInSpecResource
{
    [DscProperty(Key)]
    [string] $Name

    [DscProperty()]
    [string] $GithubPath

    [DscProperty()]
    [string] $AttributesYmlContent

    [DscProperty(NotConfigurable)]
    [string] $Result

    [DscProperty(NotConfigurable)]
    [InSpec_Reason[]] $Reasons

    [MSFT_ChefInSpecResource] Get()
    {
        throw 'The Get method is not implemented for this Audit resource.'
    }

    [bool] Test()
    {
        throw 'The Test method is not implemented for this Audit resource.'
    }

    [void] Set()
    {
        throw 'The Set method is not implemented for this Audit resource.'
    }
}
