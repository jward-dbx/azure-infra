# Private DNS Zone for SQL Server
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# SQL Server
resource "azurerm_mssql_server" "main" {
  name                                 = var.server_name
  location                             = var.location
  resource_group_name                  = var.resource_group_name
  version                              = var.server_version
  administrator_login                  = var.admin_login
  administrator_login_password         = var.admin_password
  minimum_tls_version                  = var.min_tls_version
  public_network_access_enabled        = var.public_network_access_enabled
  outbound_network_restriction_enabled = false
  connection_policy                    = "Default"
  tags                                 = var.tags

  azuread_administrator {
    login_username              = var.azuread_admin_login
    object_id                   = var.azuread_admin_object_id
    tenant_id                   = var.azuread_admin_tenant_id
    azuread_authentication_only = false
  }
}

# SQL Databases
resource "azurerm_mssql_database" "databases" {
  for_each = var.databases

  name                        = each.value.name
  server_id                   = azurerm_mssql_server.main.id
  collation                   = each.value.collation
  sku_name                    = each.value.sku_name
  max_size_gb                 = each.value.max_size_gb
  min_capacity                = each.value.min_capacity
  auto_pause_delay_in_minutes = 60
  geo_backup_enabled          = true
  ledger_enabled              = false
  read_scale                  = false
  storage_account_type        = "Local"
  zone_redundant              = false
  tags                        = var.tags

  transparent_data_encryption_enabled = true

  short_term_retention_policy {
    retention_days           = 7
    backup_interval_in_hours = 12
  }

  long_term_retention_policy {
    weekly_retention  = "PT0S"
    monthly_retention = "PT0S"
    yearly_retention  = "PT0S"
    week_of_year      = 1
  }
}

# Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = var.private_endpoint_name
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }
}
