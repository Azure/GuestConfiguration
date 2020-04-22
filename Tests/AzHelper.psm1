$AZURE_AUTOMATION_TEST_SUBSCRIPTION = 'Guest Configuration Automation Test'
$Azure_API_TOKEN_EXPIRATION_HR = 1
$Azure_SUBSCRIPTION_ID = $Env:AZURESUBSCRIPTIONID
if ((Test-Path Env:\DSC_AZUREDEVOPS_ENVIRONMENT_TEST_REGION) -and ($env:DSC_AZUREDEVOPS_ENVIRONMENT_TEST_REGION -eq 'Test'))
{
    # For adhoc testing in test region use a different subscription 
    $Azure_SUBSCRIPTION_ID = $Env:Azure_Test_SUBSCRIPTION_ID
}

<## Install ##>

function Install-AzLibraries{
    param()
    
    #Install-packageprovider nuget -force
    
    # Install Az Libraries
    Install-Module Az -AllowClobber -Force | Out-Null
    
    Import-Module Az -Force 
    
}

<#
.Synopsis
   Test if current enviroment is Azure DevOps worker enviroment.
.DESCRIPTION
   If the current enviroment is Azure DevOps worker enviroment the varaibles defined in the projects Azure DevOps.yml will be availabe.
.EXAMPLE
   Test-ServicePrincipalAccountInEnviroment 
#>
function Test-ServicePrincipalAccountInEnviroment
{
    param()
     return (Test-Path Env:/AZURE_SERVICEPRINCIPALPASSWORD) -and`
            (Test-Path Env:/AZURE_SERVICEPRINCIPALUSERNAME) -and`
            (Test-Path Env:/AZURE_TENANTID)
}

<#
.Synopsis
   Login to Azure Service
.DESCRIPTION
   This will log-in to azure using a service principal account information is available on the current enviroment.
.EXAMPLE
   Login-ToTestAzureAcccountpackageprovider 
#>
function Login-ToTestAzAccount
{
      param(
          [string]
          $SubscriptionID=$Azure_SUBSCRIPTION_ID
      )
       
      if (-not(Test-ServicePrincipalAccountInEnviroment))
      {
          throw "Test Service Principal account is only availabe under the Azure DevOps worker context"
      }

    
      $secPassword = ConvertTo-SecureString $env:AzureServicePrincipalPassword -AsPlainText -Force
      $servicePrincipalCreds = [System.Management.Automation.PSCredential]::new($env:AzureServicePrincipalUserName, $secPassword)
      Login-AzAccount -Credential $servicePrincipalCreds -ServicePrincipal -TenantId $env:AzureTenantID
      Select-AzSubscription -SubscriptionId $SubscriptionID
}

<#
.Synopsis
   Generate Azure Service token. Detail description of access token can be found here https://msdn.microsoft.com/en-us/library/hh454950.aspx
.DESCRIPTION
   This token will be generated using the test service principal account and will have 1 hr duration for expriation and will be used to invoke Azure REST APIs
.EXAMPLE
   Get-AzureAccessTokenInAzureDevOps
#>
function Get-AzureAccessTokenInAzureDevOps
{
    param()
    if (-not(Test-ServicePrincipalAccountInEnviroment))
    {
      throw "Test Service Principal account is only availabe under the Azure DevOps worker context"
    }
  
    $TokenEndpoint = {https://login.windows.net/{0}/oauth2/token} -f $env:AzureTenantID
    $ARMResource = "https://management.core.windows.net/";
    $Body = @{
            'resource'= $ARMResource
            'client_id' = $env:AzureServicePrincipalUserName
            'grant_type' = 'client_credentials'
            'client_secret' =  $env:AzureServicePrincipalPassword
    }    
    $params = @{
        ContentType = 'application/x-www-form-urlencoded'
        Headers = @{'accept'='application/json'}
        Body = $Body
        Method = 'Post'
        URI = $TokenEndpoint
    }    
    $token = Invoke-RestMethod @params
    return $token
}
