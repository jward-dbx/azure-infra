output "workspace_id" {
  description = "The ID of the Databricks workspace"
  value       = azurerm_databricks_workspace.main.id
}

output "workspace_url" {
  description = "The workspace URL of the Databricks workspace"
  value       = azurerm_databricks_workspace.main.workspace_url
}

output "workspace_resource_id" {
  description = "The Azure resource ID of the Databricks workspace"
  value       = azurerm_databricks_workspace.main.id
}

output "access_connector_id" {
  description = "The ID of the Databricks Access Connector"
  value       = azurerm_databricks_access_connector.main.id
}

output "access_connector_principal_id" {
  description = "The principal ID of the Databricks Access Connector identity"
  value       = azurerm_databricks_access_connector.main.identity[0].principal_id
}

output "managed_resource_group_id" {
  description = "The ID of the managed resource group"
  value       = azurerm_databricks_workspace.main.managed_resource_group_id
}
