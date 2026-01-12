# Databricks Module

This module creates Azure Databricks workspace with VNet injection and an Access Connector for Unity Catalog.

## Resources Created

- Azure Databricks Workspace (Premium SKU)
- Databricks Access Connector with system-assigned managed identity
- VNet injection configuration with custom subnets

## Usage

```hcl
module "databricks" {
  source = "../../modules/databricks"

  location                = "eastus2"
  resource_group_name     = "rg-example"
  workspace_name          = "dbx-example"
  sku                     = "premium"
  managed_resource_group_name = "mrg-example"
  access_connector_name   = "ac-example"
  
  no_public_ip                    = true
  public_network_access_enabled   = true
  
  virtual_network_id              = module.networking.vnet_id
  private_subnet_name             = module.networking.subnet_databricks_private_name
  public_subnet_name              = module.networking.subnet_databricks_public_name
  private_subnet_nsg_association_id = module.networking.nsg_association_private_id
  public_subnet_nsg_association_id  = module.networking.nsg_association_public_id
  
  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| location | Azure region | string | yes |
| resource_group_name | Resource group name | string | yes |
| workspace_name | Databricks workspace name | string | yes |
| sku | Workspace SKU (standard/premium/trial) | string | no (default: premium) |
| managed_resource_group_name | Managed RG name | string | yes |
| access_connector_name | Access connector name | string | yes |
| no_public_ip | Disable public IPs | bool | no (default: true) |
| public_network_access_enabled | Enable public access | bool | no (default: true) |
| virtual_network_id | VNet ID for injection | string | yes |
| private_subnet_name | Private subnet name | string | yes |
| public_subnet_name | Public subnet name | string | yes |
| private_subnet_nsg_association_id | Private NSG association ID | string | yes |
| public_subnet_nsg_association_id | Public NSG association ID | string | yes |
| tags | Resource tags | map(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| workspace_id | Databricks workspace ID |
| workspace_url | Workspace URL |
| access_connector_id | Access connector ID |
| access_connector_principal_id | Managed identity principal ID |
| managed_resource_group_id | Managed resource group ID |

## Notes

- The workspace is configured with VNet injection for enhanced security
- No public IP is enabled by default for worker nodes
- Access Connector uses system-assigned managed identity for Unity Catalog
- Requires pre-configured VNet with delegated subnets
