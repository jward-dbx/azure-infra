output "server_id" {
  description = "The ID of the SQL Server"
  value       = azurerm_mssql_server.main.id
}

output "server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "server_name" {
  description = "The name of the SQL Server"
  value       = azurerm_mssql_server.main.name
}

output "database_ids" {
  description = "Map of SQL database names to their IDs"
  value       = { for k, db in azurerm_mssql_database.databases : k => db.id }
}

output "private_endpoint_id" {
  description = "The ID of the SQL Server private endpoint"
  value       = azurerm_private_endpoint.sql.id
}

output "private_endpoint_ip" {
  description = "The private IP address of the SQL Server private endpoint"
  value       = azurerm_private_endpoint.sql.private_service_connection[0].private_ip_address
}

output "private_dns_zone_id" {
  description = "The ID of the private DNS zone"
  value       = azurerm_private_dns_zone.sql.id
}
