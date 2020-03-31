$AZURE_AUTOMATION_TEST_SUBSCRIPTION = 'Guest Configuration Automation Test'
$Azure_API_TOKEN_EXPIRATION_HR = 1
$Azure_SUBSCRIPTION_ID = $Env:Azure_SUBSCRIPTION_ID
if ((Test-Path Env:\DSC_AZUREDEVOPS_ENVIRONMENT_TEST_REGION) -and ($env:DSC_AZUREDEVOPS_ENVIRONMENT_TEST_REGION -eq 'Test'))
{
    # For adhoc testing in test region use a different subscription 
    $Azure_SUBSCRIPTION_ID = $Env:Azure_Test_SUBSCRIPTION_ID
}

<## Install ##>

function Install-AzGuestConfiguration{
    param()
    
    Install-Module -Name Az.GuestConfiguration -Force
    
    return
}

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
     return (Test-Path Env:/AzureServicePrincipalPassword) -and`
            (Test-Path Env:/AzureServicePrincipalUserName) -and`
            (Test-Path Env:/AzureTenantID)
}



# Test if we are currently logged in to Azure.
function Test-AzureLoggedIn { 
    
    return ![string]::IsNullOrEmpty($(Get-AzContext).Account)
}
# Test for env variable before choosing how to login to Azure     
function Login-ToAzure
{
    param(
        [string]
        $SubscriptionID=$Azure_SUBSCRIPTION_ID
    )
    if((Test-Path env:\AZUREDEVOPS) -or (Test-Path env:\PKGES)){
      
        Login-ToTestAzAccount -SubscriptionID $SubscriptionID
    }
    else {
        #This will prompt users to enter thier azure credentials
        Login-AzAccount
    }
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


# Generate the API token in dev/test machine.
function  Get-AzureAccessTokenDevMachine{
    param()

    # Check if ArmClient is installed, Otherwise install it.
    # Detail about the armclient tool can be found here <https://github.com/projectkudu/ARMClient/wiki> 
    $ExeInPath = Get-Command ARMClient.exe -ea SilentlyContinue
    if($ExeInPath -eq $null)
    {
        # Install the arm client.
        choco install ARMClient
    }
    ARMClient.exe login | out-null
    ARMClient.exe token | out-null  
    $token =  Get-Clipboard
    return $token
}



# Save the API token to environment.
function Set-EnvAzureApiToken
{  
    param($Token)
    $Token_ExpiryDate = [DateTime]::Now.AddHours($Azure_API_TOKEN_EXPIRATION_HR)
    $env:Token = $Token
    $env:TokenExpiryDate = $Token_ExpiryDate
}

# Read the API token from environment if it has not expired.
function Get-EnvAzureApiTokenInternal
{
    param()
    if (Test-Path Env:\Token)
    {
        if([DateTime]::Compare([DateTime]::Now, $env:TokenExpiryDate) -eq -1)
        {
            return $env:Token
        }
    }
    return $null
}

#
function Get-AzureApiToken
{
    param()
    
    $cachedToken = Get-EnvAzureApiTokenInternal
    if ($cachedToken -ne $null)
    {
        return $cachedToken
    } 
    if (Test-ServicePrincipalAccountInEnviroment)
    {
        $apiToken = Get-AzureAccessTokenInAzureDevOps
        $token = $apiToken.access_token
        Set-EnvAzureApiToken -Token $token
    }
    else
    {
        $token = Get-AzureAccessTokenDevMachine       
        Set-EnvAzureApiToken -Token $token
    }
    return $token
}

function Get-configurationAssignment{
    param($vmName,
    $policyAssignmentName,
    $subscriptionId = $Azure_SUBSCRIPTION_ID,
    $resourceGroup = $env:TestAzureResourceGroupName
    )

    $token = Get-AzureAccessTokenInAzureDevOps 
    $headers = @{
                'Authorization'="Bearer $($token.access_token)"
                'Content-Type'= 'application/json'
                }
    $uriFormat = $uriFormat = 'https://management.azure.com/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Compute/virtualMachines/{2}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{3}?api-version=2018-11-20'
    $getPolicyAssignmentUri = ($uriFormat -f $subscriptionId, $resourceGroup,$vmName, $policyAssignmentName)
    $response =  Invoke-RestMethod -Uri $getPolicyAssignmentUri -Headers $headers
    if ($null-ne $response -and $null -ne $response.properties)
    {
       return $response.properties.complianceStatus
    }
    else {
        return $null    
    }
    
}

function Get-AllConfigurationAssignmentBySubscription{
    
    [CmdletBinding()]
    [OutputType([int])]
    param(
    $subscriptionId = $Azure_SUBSCRIPTION_ID
    
    )

    $token = Get-AzureAccessTokenInAzureDevOps 
    $headers = @{
                'Authorization'="Bearer $($token.access_token)"
                'Content-Type'= 'application/json'
                }
                                                            
    $uriFormat = $uriFormat = 'https://management.azure.com/subscriptions/{0}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments?api-version=2018-11-20'
    $getPolicyAssignmentUri = ($uriFormat -f $subscriptionId)
    $response =  Invoke-RestMethod -Uri $getPolicyAssignmentUri -Headers $headers
    if ($null-ne $response -and $null -ne $response.Value)
    {
        $assignCount = $response.Value.Count
        return $assignCount
    }
    else {
        return $null    
    }
    
}

function Get-AllConfigurationAssignmentByResourceGroup{
   
    [CmdletBinding()]
    [OutputType([int])] 
    param(
        $subscriptionId = $Azure_SUBSCRIPTION_ID,
        $resourceGroup = $env:TestAzureResourceGroupName
    )

    $token = Get-AzureAccessTokenInAzureDevOps 
    $headers = @{
                'Authorization'="Bearer $($token.access_token)"
                'Content-Type'= 'application/json'
                }
    $uriFormat = $uriFormat = 'https://management.azure.com/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments?api-version=2018-11-20'
    $getPolicyAssignmentUri = ($uriFormat -f $subscriptionId, $resourceGroup)
    $response =  Invoke-RestMethod -Uri $getPolicyAssignmentUri -Headers $headers
    
    if ($null-ne $response -and $null -ne $response.Value)
    {
       $assignCount = $response.Value.Count
       return $assignCount
    }
    else {
        return $null    
    }
    
}


function Remove-PolicyAssignment{
    param(
    $resourceGroupName,
    $policyAssignmentName
    )

    $grp = Get-AzResourceGroup -Name $resourceGroupName
    if ($null -eq $grp)
    {
      throw ('No Resource Group found with name {0}' -f $resourceGroupName)
    }

    $pol = Get-AzPolicyAssignment -Name $policyAssignmentName -Scope $grp.ResourceId
    if ($null -eq $pol)
    {
            throw ('No policy assignment found with name {0}' -f $policyAssignmentName)
    }

    Write-Output 'Start deleting test Policy Assignment'
    Remove-AzPolicyAssignment -Id $p.PolicyAssignmentId
}

function Remove-TestResourceGroup{
    param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]
    $ResourceGroupName,
    
    [string]
    $SubscriptionID=$Azure_SUBSCRIPTION_ID
    )
    if (Test-ServicePrincipalAccountInEnviroment)
    {
        Login-ToTestAzAccount -SubscriptionID $SubscriptionID
    }
    Remove-AzResourceGroup -Name $ResourceGroupName -Confirm:$false -Force
}

function CleanUp-OldResourceGroups{
    param(
    [string]
    $SubscriptionID=$Azure_SUBSCRIPTION_ID
    )
    if (Test-ServicePrincipalAccountInEnviroment)
    {
        Login-ToTestAzAccount -SubscriptionID $SubscriptionID
    }

    $pkgesRGs = Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -match 'PKGES'}

    $yesterday = (Get-Date).AddDays(-1).ToShortDateString();

    foreach($rg in $pkgesRGs)
    {
        if(($null -ne $rg.Tags) -and ($rg.Tags.ContainsKey('CreatedDate')))
        {
            if($rg.Tags.CreatedDate -lt $yesterday)
            {
                Write-Output("Removing " + $rg.ResourceGroupName)
                Remove-AzResourceGroup -Name $rg.ResourceGroupName -Confirm:$false -Force
            }
        }
    }

    $polRGs = Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -match 'PolicyE2ETest'}
    $sortedRGs = $polRGs | Sort-Object {$_.Tags.CreatedDate}

    # Keep the VMs from last test run and delete rest of the Resource groups
    for($i = 0; $i -lt ($sortedRGs.Length - 1); $i++) {
        Write-Output("Removing " + $sortedRGs[$i].ResourceGroupName)
        Remove-AzResourceGroup -Name $sortedRGs[$i].ResourceGroupName -Confirm:$false -Force   
    }
}

    
function Deploy-SetupTemplate {
    [CmdletBinding()]
    param(
        [System.Collections.Hashtable]
        $InitativeIdAndParams,

        [string]
        $OS,

        [string]
        $resourceGroupName,

        [string]
        $SubscriptionID=$Azure_SUBSCRIPTION_ID,

        [string]
        $DeploymentLocation='westus'
    )
    
    Login-ToAzure -SubscriptionID $SubscriptionID
    
    $basePath = Get-Module 'AzHelper' | % ModuleBase
    $templatePath = Join-Path $basePath 'template\dsc_setup_template.json'
    $templateParameterPath = Join-Path $basePath 'template\dsc_setup_template_parameter.json'
    
    Push-Location (Join-Path $basePath 'template')

    if($resourceGroupName){
        $rgName =  $resourceGroupName
    }
    else
    {
        # Create a unique resource group for each run.
        $rgName = "PolicyE2ETest_$((Get-Date).ToString('ss_mm_hh_MM-dd-yyyy'))"
    }

    # Save resource group name in system environment.
    [System.Environment]::SetEnvironmentVariable('TestAzureResourceGroupName', $rgName, [System.EnvironmentVariableTarget]::Machine)
    [System.Environment]::SetEnvironmentVariable('TestAzureResourceGroupName', $rgName, [System.EnvironmentVariableTarget]::Process)

    if (Test-Path Env:\DSC_AZUREDEVOPS_ENVIRONMENT_TEST_REGION)
    {
       if ($env:DSC_AZUREDEVOPS_ENVIRONMENT_TEST_REGION -eq 'Test')
       {
            $DeploymentLocation = 'centraluseuap'
            $imageinfo = Get-Content (Join-Path $basePath 'template\all_test_vm.json')
       }
    }
    
    $today = (Get-Date).ToShortDateString()

    Write-Output ('Creating test resource group name: "{0}"' -f  $rgName)

    New-AzResourceGroup -Name $rgName -Location $DeploymentLocation -Tag @{CreatedDate=$today}
    
    #Create an Assingment for every Initiative
    $policyNames = @()
    if($InitativeIdAndParams.keys)
    { 
        $InitativeIdAndParams.keys | ForEach-Object{
            
            Write-Output ('Initiative ID: "{0}"' -f  $_)
            
            if($InitativeIdAndParams[$_].Parameters) {
                $policyparams = [Newtonsoft.Json.Linq.JObject]::Parse($InitativeIdAndParams[$_].Parameters)
            }
            else {
                $policyparams = $null
            }
            $policyType = $InitativeIdAndParams[$_].PolicyType
            $assignDisplayName = $InitativeIdAndParams[$_].AssignDisplayName
            
            # Create a unique policy assignment name 
            $plName = (New-Guid).ToString()
            $policyNames += $plName
            
            if($policyparams){
                $templateParams = @{
                    assignmentName=$plName
                    displayName=$assignDisplayName
                    initiativeId="$_"
                    policytype=$policyType
                    policyparams=$policyparams
                }
            }
            else{
                $templateParams = @{
                    assignmentName=$plName
                    displayName=$assignDisplayName
                    initiativeId="$_"
                    policytype=$policyType
                }
            }
            $templateParams  | Out-String | Write-Host
            Write-Output ('Start creating a unique policy assignment name "{0}"' -f $plName)
            New-AzResourceGroupDeployment -TemplateFile .\PolicyAssignment\AzurePolicyAssignment.json `
                                            -TemplateParameterObject $templateParams `
                                            -ResourceGroupName $rgName `
                                            -ErrorVariable policyAssignCreation 

        }
    }
    else{
        # Create a unique policy assignment name 
        [string]$plName = (New-Guid).ToString()
        $policyNames += $plName
        $templateParams = @{
            assignmentName=$plName
        }
        
        Write-Output ('Start creating a unique policy assignment name "{0}"' -f $plName)
        
        New-AzResourceGroupDeployment -TemplateFile .\PolicyAssignment\AzurePolicyAssignment.json `
                                            -TemplateParameterObject $templateParams `
                                            -ResourceGroupName $rgName `
                                            -ErrorVariable policyAssignCreation 
    }
  
    if ($policyAssignCreation)
            {
                throw "Creating a policy Assignment failed"
            }

    # Wait 60 sec until the policy assignment is usable. (Known issue)
    # https://github.com/terraform-providers/terraform-provider-azuread/issues/4
    Start-Sleep -Seconds 120

    Write-Output ('Start creating Azure Resource in Resource Group"{0}"' -f $rgName)
    $policyNames | % {
        New-AzResourceGroupDeployment -TemplateFile .\PolicyRoleAssignment\AssignmentRole.json `
                                       -TemplateParameterObject @{assignmentName = "$_"} `
                                       -ResourceGroupName $rgName `
                                       -ErrorVariable roleAssignError
    }
    
    if($roleAssignError)
    {
        throw "Assigning a contributor role to policy failed"
    }

    switch ($OS) {
        
        "windows" { $imageinfo = Get-Content (Join-Path $basePath 'template\windows_vm_imageList.json') ; break }
        
        "Linux" { $imageinfo = Get-Content (Join-Path $basePath 'template\Linux_vm_imageList.json') ; break }
        
        Default {break}
    }

    
    # Policy has a known issue for greenfield scenario where assignement to a resource group may not take in to effect until 
    # we log-out and log-in or wait for 30 min.
    Logout-AzAccount
    Login-ToTestAzAccount -SubscriptionID $SubscriptionID
    Write-Output ('Waiting for 30 min before creating VMS in the resource group')
    Start-Sleep -Seconds (30*60)
        
    Write-Output ('Start Creating VMS on the resource group "{0}"' -f $rgName)
        
    if (Test-ServicePrincipalAccountInEnviroment)
    {
        if($imageinfo){
            $imageinfojson = [Newtonsoft.Json.Linq.JObject]::Parse($imageinfo)
            Write-Output ('Changing deployment location of all Virtual Machines to "{0}"' -f $DeploymentLocation)
            if($DeploymentLocation -eq 'eastus2euap' -or $DeploymentLocation -eq 'centraluseuap'){
                foreach($image in $imageinfojson["imageList"]){
                $image.location = $DeploymentLocation
                }
            }
        # Use encrypted username and pwd from envirnoment.
            $templateparams =  @{
                adminUsername= $env:VMUserName
                adminPassword = $env:VMPassword
                dnsNameForPublicIP = "test-policy2"
                imageInfo=$imageinfojson
            }
        }
        else{
            $templateparams =  @{
                adminUsername= $env:VMUserName
                adminPassword = $env:VMPassword
                dnsNameForPublicIP = "test-policy2"
            }
        }
        New-AzResourceGroupDeployment -Name ((Get-ChildItem $templatePath).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
                                       -ResourceGroupName $rgName `
                                       -TemplateFile $templatePath `
                                       -TemplateParameterObject $templateparams `
                                       -Force -Verbose `
                                       -ErrorVariable ErrorMessages
    }
    else
    {
        New-AzResourceGroupDeployment -Name ((Get-ChildItem $templatePath).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
                                       -ResourceGroupName $rgName `
                                       -TemplateFile $templatePath `
                                       -TemplateParameterFile $templateParameterPath `
                                       -Force -Verbose `
                                       -ErrorVariable ErrorMessages
    }
    if ($ErrorMessages) {
        Write-Output '', 'Template to deploy test VM returned the following errors:', @(@($ErrorMessages) | ForEach-Object { $_.Exception.Message.TrimEnd("`r`n") })
    }
    Pop-Location
    
    # Once all test VMS are created we need to wait for about 1 hr until 'DeployIfNotExist' and 'AuditIfNotExist' is executed on each VM.
    Write-Output ('Waiting for about 1 hr until DeployIfNotExist and AuditIfNotExist is executed on each VM')
    Start-Sleep -Seconds (60*60)
}
