

Write-Host "Setting Variables for resources" -ForegroundColor Green
$RG="cyberchef-lab"
$LOCATION="eastus"
$VNET="cyberchef-vnet"
$VM_SUBNET="vm-subnet"
$ACI_SUBNET="aci-subnet"
$NSG="vm-nsg"
$NIC="vm-nic"
$VM="win-vm"
$IP="vm-public-ip"
$ACI="cyberchef"
$MYIP="1.1.1.1"  # Replace with your actual IP
$USERNAME="azureuser"
$PASSWORD="YouGottaChangeMe!Pass123" # Change this please.

Write-Host "Creating the resource Group $($RG)" -ForegroundColor Green 
az group create --name $RG --location $LOCATION

Write-Host "Creating the Virtual Network $($VNET)" -ForegroundColor Green 
az network vnet create --resource-group $RG --name $VNET --address-prefix 10.10.0.0/16 --subnet-name $VM_SUBNET --subnet-prefix 10.10.1.0/24

Write-Host "Creating separate subnet for ACI with delegation" -ForegroundColor Green 
az network vnet subnet create --resource-group $RG --vnet-name $VNET --name $ACI_SUBNET --address-prefix 10.10.2.0/24 --delegations Microsoft.ContainerInstance/containerGroups

Write-Host "Creating NSG + RDP rule from your IP only" -ForegroundColor Green 
az network nsg create --name $NSG --resource-group $RG --location $LOCATION
az network nsg rule create --resource-group $RG --nsg-name $NSG --name Allow-RDP-From-MyIP --protocol tcp --priority 100 --destination-port-range 3389 --access allow --direction inbound --source-address-prefix $MYIP

Write-Host "Creating public IP for VM" -ForegroundColor Green 
az network public-ip create --resource-group $RG --name $IP --allocation-method Static --sku Standard

Write-Host "Creating NIC" -ForegroundColor Green 
az network nic create --resource-group $RG --name $NIC --vnet-name $VNET --subnet $VM_SUBNET --network-security-group $NSG --public-ip-address $IP

Write-Host "Creating Windows VM" -ForegroundColor Green 
az vm create --resource-group $RG --name $VM --image microsoftwindowsdesktop:windows-11:win11-24h2-pro:latest --admin-username $USERNAME --admin-password $PASSWORD --nics $NIC --size Standard_B2s

Write-Host "Deploying the ACI with CyberChef Installed" -ForegroundColor Green 
az container create --resource-group $RG --name $ACI --image ghcr.io/gchq/cyberchef --vnet $VNET --subnet $ACI_SUBNET --ports 80 --ip-address Private --cpu 1 --memory 1.5 --location $LOCATION --os-type=Linux

Write-Host "Your Azure Container instance is at IP:$(az container show --resource-group $RG --name $ACI --query ipAddress.ip --output tsv)" "Login to the VM and in your browser type http://$(az container show --resource-group $RG --name $ACI --query ipAddress.ip --output tsv)" -ForegroundColor Green
