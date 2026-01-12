output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_default_id" {
  description = "The ID of the default subnet"
  value       = azurerm_subnet.default.id
}

output "subnet_sql_private_endpoints_id" {
  description = "The ID of the SQL private endpoints subnet"
  value       = azurerm_subnet.sql_private_endpoints.id
}

output "subnet_databricks_private_id" {
  description = "The ID of the Databricks private subnet"
  value       = azurerm_subnet.databricks_private.id
}

output "subnet_databricks_private_name" {
  description = "The name of the Databricks private subnet"
  value       = azurerm_subnet.databricks_private.name
}

output "subnet_databricks_public_id" {
  description = "The ID of the Databricks public subnet"
  value       = azurerm_subnet.databricks_public.id
}

output "subnet_databricks_public_name" {
  description = "The name of the Databricks public subnet"
  value       = azurerm_subnet.databricks_public.name
}

output "nsg_databricks_id" {
  description = "The ID of the Databricks Network Security Group"
  value       = azurerm_network_security_group.databricks.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.main.id
}

output "nsg_association_private_id" {
  description = "The ID of the private subnet NSG association"
  value       = azurerm_subnet_network_security_group_association.databricks_private.id
}

output "nsg_association_public_id" {
  description = "The ID of the public subnet NSG association"
  value       = azurerm_subnet_network_security_group_association.databricks_public.id
}
