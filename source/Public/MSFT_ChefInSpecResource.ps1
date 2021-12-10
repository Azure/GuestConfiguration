class InSpec_Statistics
{
    [string] $duration
}

class InSpec_Controls
{
    [string] $id
    [string] $profile_id
    [string] $profile_sha256
    [string] $status
    [string] $code_desc
    [string] $message
}

class InSpec_Results
{
    [InSpec_Controls[]] $controls
    [string] $version

    [InSpec_Statistics] $statistics
    [string] $status
}

class InSpec_Reason
{
    [string] $Phrase
    [string] $Code
}

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

    [MSFT_ChefInSpecResource] Get() {
        throw 'The Get method is not implemented for this Audit resource.'
    }

    [bool] Test() {
        throw 'The Test method is not implemented for this Audit resource.'
    }

    [void] Set() {
        throw 'The Set method is not implemented for this Audit resource.'
    }
}
