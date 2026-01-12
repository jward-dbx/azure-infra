# Storage Module

This module creates an Azure Storage Account with Data Lake Gen2 capabilities and security best practices.

## Resources Created

- Azure Storage Account (StorageV2)
- Hierarchical namespace enabled (Data Lake Gen2)
- Blob soft delete and retention policies
- Large file share support

## Usage

```hcl
module "storage" {
  source = "../../modules/storage"

  location               = "eastus2"
  resource_group_name    = "rg-example"
  storage_account_name   = "stexample123"
  account_tier           = "Standard"
  account_replication_type = "LRS"
  enable_hns             = true
  enable_large_file_share = true
  
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
| storage_account_name | Storage account name (3-24 lowercase alphanumeric) | string | yes |
| account_tier | Performance tier (Standard/Premium) | string | no (default: Standard) |
| account_replication_type | Replication type (LRS/GRS/RAGRS/ZRS/GZRS/RAGZRS) | string | no (default: LRS) |
| enable_hns | Enable hierarchical namespace (Data Lake Gen2) | bool | no (default: true) |
| enable_large_file_share | Enable large file share (up to 100 TiB) | bool | no (default: true) |
| tags | Resource tags | map(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| storage_account_id | Storage account ID |
| storage_account_name | Storage account name |
| primary_blob_endpoint | Primary blob endpoint URL |
| primary_dfs_endpoint | Primary DFS endpoint URL (Data Lake Gen2) |
| primary_access_key | Primary access key (sensitive) |
| primary_connection_string | Primary connection string (sensitive) |

## Notes

- Storage account name must be globally unique and 3-24 lowercase alphanumeric characters
- Hierarchical namespace (HNS) enables Data Lake Gen2 capabilities
- HTTPS traffic is enforced
- Public blob access is disabled by default
- Blob soft delete is enabled with 7-day retention
- Minimum TLS version is 1.2
- For production, consider using GRS or GZRS for geo-redundancy
