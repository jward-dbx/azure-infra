# Databricks Access Connector
resource "azurerm_databricks_access_connector" "main" {
  name                = var.access_connector_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

# Databricks Workspace
resource "azurerm_databricks_workspace" "main" {
  name                                = var.workspace_name
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  sku                                 = var.sku
  managed_resource_group_name         = var.managed_resource_group_name
  public_network_access_enabled       = var.public_network_access_enabled
  customer_managed_key_enabled        = false
  infrastructure_encryption_enabled   = false
  tags                                = var.tags

  custom_parameters {
    no_public_ip                                         = var.no_public_ip
    private_subnet_name                                  = var.private_subnet_name
    public_subnet_name                                   = var.public_subnet_name
    virtual_network_id                                   = var.virtual_network_id
    private_subnet_network_security_group_association_id = var.private_subnet_nsg_association_id
    public_subnet_network_security_group_association_id  = var.public_subnet_nsg_association_id
  }

  depends_on = [
    var.private_subnet_nsg_association_id,
    var.public_subnet_nsg_association_id
  ]
}
