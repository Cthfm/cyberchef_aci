# CyberChef Lab Deployment

This script automates the deployment of a CyberChef lab environment in Azure. The environment consists of a Windows 11 VM and a CyberChef container instance in an isolated virtual network.

## Overview

CyberChef is a web-based application for data analysis, encoding, encryption, and much more. This script sets up:

- A Windows 11 VM that you can RDP into
- A containerized instance of CyberChef running in Azure Container Instances (ACI)
- Proper networking with NSG rules to limit access to your IP only

## Prerequisites

- Azure CLI installed and configured
- PowerShell (for Windows users) or PowerShell Core (for cross-platform)
- An active Azure subscription
- Your public IP address

## Installation

1. Download the script to your local machine
2. Open the script and update the following variables:
   - `$MYIP`: Replace `1.1.1.1` with your actual public IP address
   - `$PASSWORD`: Change the default password to a secure one
3. Run the script using PowerShell

```powershell
.\deploy-cyberchef-lab.ps1
```

## Resources Created

The script deploys the following Azure resources:

| Resource | Type | Description |
|----------|------|-------------|
| Resource Group | `cyberchef-lab` | Container for all resources |
| Virtual Network | `cyberchef-vnet` | Network with multiple subnets |
| Subnets | `vm-subnet`, `aci-subnet` | Separate subnets for VM and container |
| NSG | `vm-nsg` | Network Security Group with RDP rule |
| VM | `win-vm` | Windows 11 Pro VM (Standard_B2s) |
| Container Instance | `cyberchef` | ACI running CyberChef |

## Security Features

- RDP access is restricted to your specified IP address only
- CyberChef container has only private IP address (not exposed to internet)
- Resources are isolated in their own virtual network

## Usage

1. After deployment, RDP to your Windows 11 VM using the public IP address displayed at the end of the script
2. From within the VM, open a browser and navigate to the CyberChef instance using the URL shown in the output

## Customization

You can modify the script to change:
- VM size (currently Standard_B2s)
- Region (currently East US)
- Network address spaces
- Container resources (CPU/memory)

## Cleanup

To remove all resources when you're done:

```powershell
az group delete --name cyberchef-lab --yes
```

## Notes

- The default Windows VM username is `azureuser`
- The CyberChef container image is pulled from `ghcr.io/gchq/cyberchef`
- The VM uses the latest Windows 11 24H2 Pro image
