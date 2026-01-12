# SQL Server Module

This module creates Azure SQL Server with databases, private endpoint, and private DNS zone for secure connectivity.

## Resources Created

- Azure SQL Server with Azure AD authentication
- Multiple SQL databases (configurable)
- Private endpoint for secure connectivity
- Private DNS zone for name resolution

## Usage

```hcl
module "sql" {
  source = "../../modules/sql"

  location            = "eastus2"
  resource_group_name = "rg-example"
  server_name         = "sql-example"
  server_version      = "12.0"
  
  admin_login    = "sqladmin"
  admin_password = var.sql_admin_password  # Use secure variable
  
  min_tls_version               = "1.2"
  public_network_access_enabled = false
  
  azuread_admin_login     = "admin@example.com"
  azuread_admin_object_id = "00000000-0000-0000-0000-000000000000"
  azuread_admin_tenant_id = "00000000-0000-0000-0000-000000000000"
  
  databases = {
    db1 = {
      name         = "database-1"
      sku_name     = "GP_S_Gen5_1"
      max_size_gb  = 32
      min_capacity = 0.5
      collation    = "SQL_Latin1_General_CP1_CI_AS"
    }
  }
  
  private_endpoint_name      = "pe-sql-example"
  private_endpoint_subnet_id = module.networking.subnet_sql_private_endpoints_id
  
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
| server_name | SQL Server name | string | yes |
| server_version | SQL Server version | string | no (default: 12.0) |
| admin_login | Admin username | string | yes (sensitive) |
| admin_password | Admin password | string | yes (sensitive) |
| min_tls_version | Minimum TLS version | string | no (default: 1.2) |
| public_network_access_enabled | Enable public access | bool | no (default: true) |
| azuread_admin_login | Azure AD admin username | string | yes |
| azuread_admin_object_id | Azure AD admin object ID | string | yes |
| azuread_admin_tenant_id | Azure AD tenant ID | string | yes |
| databases | Map of databases to create | map(object) | no |
| private_endpoint_name | Private endpoint name | string | yes |
| private_endpoint_subnet_id | PE subnet ID | string | yes |
| tags | Resource tags | map(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| server_id | SQL Server ID |
| server_fqdn | Server FQDN |
| server_name | Server name |
| database_ids | Map of database IDs |
| private_endpoint_id | Private endpoint ID |
| private_endpoint_ip | Private endpoint IP address |
| private_dns_zone_id | Private DNS zone ID |

## Notes

- Admin password should be stored securely (Azure Key Vault or environment variables)
- Private endpoint provides secure connectivity within VNet
- Azure AD authentication is configured alongside SQL authentication
- All databases include automatic backups with 7-day retention
- Transparent Data Encryption (TDE) is enabled by default
