#Check current execution policy
$policy = Get-ExecutionPolicy

# if the current policy is "Restricted", change to "RemoteSigned"
if ($policy -eq "Restricted") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "Execution policy has been changed to RemoteSigned"
} else {
    Write-Host "The current execution policy is $policy"
}

# Login Azure Account
Write-Output ""
Write-Output "Login.........."
az login
Write-Output "Login Successful"

Write-Output ""
Write-Output "Connecting Azure Account.........."
Connect-AzAccount
Write-Output "Connection Successful.........."

Write-Output ""
Write-Output "Azure Subscription"
Get-AzSubscription;

Write-Output ""
Write-Output "Resource Group List"
Write-Output "-----------------------------------------------------------------------------------------------------------"
Get-AzResourceGroup | Sort-Object ResourceGroupName | Format-Table ResourceGroupName,Location,Tags,ResourceId -AutoSize

Write-Output ""
$ResourceGroup = Read-Host "Select the desired Resource Group"
Write-Output "-----------------------------------------------------------------------------------------------------------"
$ResourceG = Get-AzResource -ResourceGroupName $ResourceGroup | Format-Table Name,ResourceGroupName,ResourceType,Location,Tags,ResourceId -AutoSize
Write-Output $ResourceG

Write-Output ""
$Resource = Read-Host "Select the Resource desired name"
Write-Output "-----------------------------------------------------------------------------------------------------------"
$Res = Get-AzResource -ExpandProperties -Name $Resource;
Write-Output "Main Properties of the selected resource"
$Res.properties | Format-Table -AutoSize


Write-Output ""
$ResourceTag = Read-Host "Select the Resource desired name to change Tag"
Write-Output "-----------------------------------------------------------------------------------------------------------"
$ResTag = Get-AzResource -Name $ResourceTag;

if ( $null -eq $ResTag ){
    Write-Output "Invalid Value"
    Write-Output ""
    Write-Output "Disconnecting from Azure Portal"
    Write-Output "-----------------------------------------------------------------------------------------------------------"
    Disconnect-AzAccount
    exit
}
else{
    $name = Read-Host "Insert Tag Name"
    $value = Read-Host "Insert Tag Value"
    #New-AzTag -Name $tagname -Value $tagvalue
    $tag = @{
        "Name"= "$name"
        "Value"= "$value"
            }
    Set-AzResource -ResourceId $ResTag.Id -Tag $tag -Force
    Write-Output Get-AzResource -Name $ResTag | Format-list
    }

pause;

Write-Output "";
Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output "Do you want to see the resource configuration detail?"
$plus = Read-Host "1(yes) or 2(no)"

if ( 1 -eq $plus){

    Write-Output ""
    Write-Output "Checking the Resource Configuration Details (StorageAccounts)"
    Write-Output "-----------------------------------------------------------------------------------------------------------"
    $SAD = Get-AzResource -ResourceType Microsoft.Storage/storageAccounts | Format-List -Property Name,ResourceGroupName,ResourceId,Kind,Location,Tags,Sku,Properties
    Write-Output $SAD
    
    Write-Output ""
    Write-Output "Checking Resource Configuration Details (AppServicesPlan)"
    Write-Output "-----------------------------------------------------------------------------------------------------------"
    $ASPD = Get-AzResource -ResourceType Microsoft.Web/serverFarms | Format-List -Property Name,ResourceGroupName,ResourceId,Kind,Location,Tags,Sku,Properties
    Write-Output $ASPD
    
    Write-Output ""
    Write-Output "Checking Resource Configuration Details (AppServicesName)"
    Write-Output "-----------------------------------------------------------------------------------------------------------"
    $ASND = Get-AzResource -ResourceType Microsoft.Web/sites | Format-List -Property Name,ResourceGroupName,ResourceId,Kind,Location,Tags,Sku,Properties
    Write-Output $ASND

}
elseif (2 -eq $plus){
    Write-Output ""
    Write-Output "Disconnecting from Azure Portal"
    Write-Output "-----------------------------------------------------------------------------------------------------------"
    Disconnect-AzAccount
    exit
}
else {
    Write-Output "Invalid Value"
    Write-Output ""
    Write-Output "Disconnecting from Azure Portal"
    Write-Output "-----------------------------------------------------------------------------------------------------------"
    Disconnect-AzAccount
    exit
}


Write-Output ""
Write-Output "Disconnecting from Azure Portal"
Write-Output "-----------------------------------------------------------------------------------------------------------"
Disconnect-AzAccount


