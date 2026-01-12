# Networking Module
module "networking" {
  source = "./modules/networking"

  location                             = var.location
  resource_group_name                  = var.resource_group_name
  vnet_name                            = var.vnet_name
  vnet_address_space                   = var.vnet_address_space
  subnet_default_prefix                = var.subnet_default_prefix
  subnet_sql_private_endpoints_prefix  = var.subnet_sql_private_endpoints_prefix
  subnet_databricks_private_prefix     = var.subnet_databricks_private_prefix
  subnet_databricks_public_prefix      = var.subnet_databricks_public_prefix
  nsg_databricks_name                  = var.nsg_databricks_name
  nat_gateway_name                     = var.nat_gateway_name
  nat_gateway_public_ip_id             = var.nat_gateway_public_ip_id
  tags                                 = var.tags
}

# Databricks Module
module "databricks" {
  source = "./modules/databricks"

  location                              = var.location
  resource_group_name                   = var.resource_group_name
  workspace_name                        = var.databricks_workspace_name
  sku                                   = var.databricks_sku
  managed_resource_group_name           = var.databricks_managed_resource_group_name
  access_connector_name                 = var.databricks_access_connector_name
  no_public_ip                          = var.databricks_no_public_ip
  public_network_access_enabled         = var.databricks_public_network_access_enabled
  virtual_network_id                    = module.networking.vnet_id
  private_subnet_name                   = module.networking.subnet_databricks_private_name
  public_subnet_name                    = module.networking.subnet_databricks_public_name
  private_subnet_nsg_association_id     = module.networking.nsg_association_private_id
  public_subnet_nsg_association_id      = module.networking.nsg_association_public_id
  tags                                  = var.tags

  depends_on = [module.networking]
}

# SQL Module
module "sql" {
  source = "./modules/sql"

  location                       = var.location
  resource_group_name            = var.resource_group_name
  server_name                    = var.sql_server_name
  server_version                 = var.sql_server_version
  admin_login                    = var.sql_admin_login
  admin_password                 = var.sql_admin_password
  min_tls_version                = var.sql_min_tls_version
  public_network_access_enabled  = var.sql_public_network_access_enabled
  azuread_admin_login            = var.sql_azuread_admin_login
  azuread_admin_object_id        = var.sql_azuread_admin_object_id
  azuread_admin_tenant_id        = var.sql_azuread_admin_tenant_id
  databases                      = var.sql_databases
  private_endpoint_name          = var.sql_private_endpoint_name
  private_endpoint_subnet_id     = module.networking.subnet_sql_private_endpoints_id
  tags                           = var.tags

  depends_on = [module.networking]
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  location                 = var.location
  resource_group_name      = var.resource_group_name
  storage_account_name     = var.storage_account_name
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  enable_hns               = var.storage_enable_hns
  enable_large_file_share  = var.storage_enable_large_file_share
  tags                     = var.tags
}
