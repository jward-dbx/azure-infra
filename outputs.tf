# Networking Outputs
output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.networking.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    default                = module.networking.subnet_default_id
    sql_private_endpoints  = module.networking.subnet_sql_private_endpoints_id
    databricks_private     = module.networking.subnet_databricks_private_id
    databricks_public      = module.networking.subnet_databricks_public_id
  }
}

output "nsg_databricks_id" {
  description = "The ID of the Databricks Network Security Group"
  value       = module.networking.nsg_databricks_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.networking.nat_gateway_id
}

# Databricks Outputs
output "databricks_workspace_id" {
  description = "The ID of the Databricks workspace"
  value       = module.databricks.workspace_id
}

output "databricks_workspace_url" {
  description = "The workspace URL of the Databricks workspace"
  value       = module.databricks.workspace_url
}

output "databricks_access_connector_id" {
  description = "The ID of the Databricks Access Connector"
  value       = module.databricks.access_connector_id
}

output "databricks_access_connector_principal_id" {
  description = "The principal ID of the Databricks Access Connector identity"
  value       = module.databricks.access_connector_principal_id
}

# SQL Server Outputs
output "sql_server_id" {
  description = "The ID of the SQL Server"
  value       = module.sql.server_id
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = module.sql.server_fqdn
}

output "sql_server_name" {
  description = "The name of the SQL Server"
  value       = module.sql.server_name
}

output "sql_database_ids" {
  description = "Map of SQL database names to their IDs"
  value       = module.sql.database_ids
}

output "sql_private_endpoint_id" {
  description = "The ID of the SQL Server private endpoint"
  value       = module.sql.private_endpoint_id
}

output "sql_private_endpoint_ip" {
  description = "The private IP address of the SQL Server private endpoint"
  value       = module.sql.private_endpoint_ip
}

# Storage Outputs
output "storage_account_id" {
  description = "The ID of the storage account"
  value       = module.storage.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.storage.storage_account_name
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint of the storage account"
  value       = module.storage.primary_blob_endpoint
}

output "storage_account_primary_dfs_endpoint" {
  description = "The primary DFS endpoint of the storage account (Data Lake Gen2)"
  value       = module.storage.primary_dfs_endpoint
}
