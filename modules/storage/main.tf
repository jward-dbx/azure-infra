# Storage Account
resource "azurerm_storage_account" "main" {
  name                             = var.storage_account_name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  account_kind                     = "StorageV2"
  access_tier                      = "Hot"
  https_traffic_only_enabled       = true
  is_hns_enabled                   = var.enable_hns
  large_file_share_enabled         = var.enable_large_file_share
  min_tls_version                  = "TLS1_2"
  public_network_access_enabled    = true
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  default_to_oauth_authentication  = false
  shared_access_key_enabled        = true
  sftp_enabled                     = false
  nfsv3_enabled                    = false
  local_user_enabled               = true
  queue_encryption_key_type        = "Service"
  table_encryption_key_type        = "Service"
  tags                             = var.tags

  blob_properties {
    versioning_enabled       = false
    change_feed_enabled      = false
    last_access_time_enabled = false

    container_delete_retention_policy {
      days = 7
    }

    delete_retention_policy {
      days                     = 7
      permanent_delete_enabled = false
    }
  }

  share_properties {
    retention_policy {
      days = 7
    }
  }
}
