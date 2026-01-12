# Networking Module

This module creates Azure networking resources including Virtual Network, subnets, Network Security Groups, and NAT Gateway.

## Resources Created

- Azure Virtual Network with custom address space
- Four subnets:
  - Default subnet
  - SQL private endpoints subnet
  - Databricks private subnet (with delegation)
  - Databricks public subnet (with delegation)
- Network Security Group with Databricks-specific rules
- NAT Gateway for outbound connectivity
- NSG associations with Databricks subnets

## Usage

```hcl
module "networking" {
  source = "../../modules/networking"

  location            = "eastus2"
  resource_group_name = "rg-example"
  vnet_name           = "vnet-example"
  vnet_address_space  = ["10.0.0.0/16"]
  
  subnet_default_prefix                = "10.0.0.0/24"
  subnet_sql_private_endpoints_prefix  = "10.0.1.0/24"
  subnet_databricks_private_prefix     = "10.0.2.0/24"
  subnet_databricks_public_prefix      = "10.0.3.0/24"
  
  nsg_databricks_name      = "nsg-databricks"
  nat_gateway_name         = "natgw-example"
  nat_gateway_public_ip_id = "/subscriptions/.../publicIPAddresses/pip-example"
  
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
| vnet_name | Virtual network name | string | yes |
| vnet_address_space | VNet address space | list(string) | yes |
| subnet_default_prefix | Default subnet CIDR | string | yes |
| subnet_sql_private_endpoints_prefix | SQL PE subnet CIDR | string | yes |
| subnet_databricks_private_prefix | Databricks private subnet CIDR | string | yes |
| subnet_databricks_public_prefix | Databricks public subnet CIDR | string | yes |
| nsg_databricks_name | NSG name | string | yes |
| nat_gateway_name | NAT Gateway name | string | yes |
| nat_gateway_public_ip_id | Public IP resource ID | string | yes |
| tags | Resource tags | map(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| vnet_id | Virtual network ID |
| vnet_name | Virtual network name |
| subnet_default_id | Default subnet ID |
| subnet_sql_private_endpoints_id | SQL PE subnet ID |
| subnet_databricks_private_id | Databricks private subnet ID |
| subnet_databricks_public_id | Databricks public subnet ID |
| nsg_databricks_id | NSG ID |
| nat_gateway_id | NAT Gateway ID |

## Notes

- The Databricks subnets include proper delegation for Azure Databricks
- NSG rules follow Azure Databricks requirements for VNet injection
- NAT Gateway requires a pre-existing public IP address
