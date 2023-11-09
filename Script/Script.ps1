Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Install-Module -Name Az -Repository PSGallery -Force -AllowClobber    # for installation of azure directory
# Update-Module -Name Az -Force # for update purpose
# Connect-AzAccount # for connecting to azure account 

$variable = Get-Content -Path ".\variable.json" | ConvertFrom-Json

$vm_name = $variable.vm_name #specify the vm name
$resource_group = $variable.resource_group # Specify the resource group name
$new_size = $variable.new_size # Specify the new size
$resource_id = $variable.resource_id

# $stateFilePath = $variable.stateFilePath # Specify the path to the directory containing the Terraform state file (1time)
# $new_file = $variable.new_file  #change 1 time

$main_file_name = "main.tf"
$path = Get-Location

$vm_block = "resource azurerm_virtual_machine $vm_name {
    feature{}
}"
$full_path = Join-Path -Path $path -ChildPath $main_file_name

if(Test-Path $full_path -PathType Leaf){
    Remove-Item -Path $full_path -Force
    Write-Host "------------------------------------UPDATING THE main.tf FILE----------------------------------------------" -ForegroundColor DarkRed
    Start-Sleep -Seconds 5
    # New-Item -Path $new_file -Force
    # Set-Content -Path $new_file -Value $vm_block
    New-Item -Path $path -Name "main.tf" -ItemType "file" -Value $vm_block -Force
    Start-Sleep -Seconds 5
    Write-Host "------------------------------------UPDATING THE main.tf FILE COMPLETE-------------------------------------" -ForegroundColor DarkRed

}
else{
    Start-Sleep -Seconds 5
    Write-Host "------------------------------------CREATING THE main.tf FILE----------------------------------------------" -ForegroundColor DarkRed
    # New-Item -Path $new_file -Force
    # Set-Content -Path $new_file -Value $vm_block
    New-Item -Path $path -Name "main.tf" -ItemType "file" -Value $vm_block -Force
    Start-Sleep -Seconds 5
    Write-Host "------------------------------------CREATION OF main.tf FILE COMPLETE-------------------------------------" -ForegroundColor DarkRed

}


$vm = Get-AzVM -ResourceGroupName $resource_group -VMName $vm_name
if($vm.HardwareProfile.VmSize -ne $new_size){
    $vm = Get-AzVM -ResourceGroupName $resource_group -VMName $vm_name
    $vm.HardwareProfile.VmSize=$new_size
    $vm | Update-AzVM
    Write-Host "The size of the VM has been modified"-ForegroundColor DarkGreen
    Write-Host "VM size change affected"-ForegroundColor DarkGreen
}else {
    Write-Host "The VM and the desired size is same so no changes has been done"-BackgroundColor DarkBlue
}
Start-Sleep -Seconds 5
Write-Host "-------------------------------------IMPORTING THE TERRAFORM STATE FILE-------------------------------------------------"-ForegroundColor DarkGreen
Start-Sleep -Seconds 5
Write-Host "-------------------------------------GENARATING THE TERRAFORM.LOCK.HCL--------------------------------------------------"-ForegroundColor DarkGreen
Start-Sleep -Seconds 5
Write-Host "-------------------------------------TERRAFORM INITIALIZATION STARTED---------------------------------------------------"-ForegroundColor DarkGreen
Start-Sleep -Seconds 5
terraform init
Start-Sleep -Seconds 5
Write-Host "-------------------------------------TERRAFORM INITIALIZATION COMPLETED-------------------------------------------------"-ForegroundColor DarkGreen
Start-Sleep -Seconds 3
Write-Host "-------------------------------------CHECKING FOR EXISTING STATE FILE---------------------------------------------------"-ForegroundColor DarkGreen


# Specify the name of the Terraform state file
$stateFileName = ".\terraform.tfstate"

if ([System.IO.File]::Exists($stateFileName)) {
    # Remove the Terraform state file
    [System.IO.File]::Delete($stateFileName)
    Write-Host "--------------------------------TERRAFORM STATE FILE FOUND IN DIRECTORY---------------------------------------------"-ForegroundColor DarkRed
    Start-Sleep -Seconds 3
    Write-Host "--------------------------------TERRAFORM STATE FILE DELETED SUCCESSFULLY.------------------------------------------"-ForegroundColor DarkRed
} else {
    Write-Host "--------------------------------TERRAFORM STATE FILE NOT FOUND.-----------------------------------------------------"-ForegroundColor DarkGreen
}

Start-Sleep -Seconds 3
Write-Host "-------------------------------------GENARATING THE TF.STATEFILE--------------------------------------------------------"-ForegroundColor DarkGreen
Start-Sleep -Seconds 3

$i = terraform import azurerm_virtual_machine.$vm_name $resource_id

if($i.ExitCode -ne 0) {
    Write-Host "AZURE VM HAS BEEN IMPORTED SUCCESSFULLY"-ForegroundColor DarkGreen 
}
else{
    Write-Host "AZURE VM IMPORT FAILURE"-BackgroundColor DarkBlue
}






