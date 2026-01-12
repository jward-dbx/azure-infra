# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Default Subnet
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_default_prefix]
}

# SQL Private Endpoints Subnet
resource "azurerm_subnet" "sql_private_endpoints" {
  name                 = "sql-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_sql_private_endpoints_prefix]
}

# Databricks Private Subnet
resource "azurerm_subnet" "databricks_private" {
  name                 = "private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_databricks_private_prefix]

  delegation {
    name = "databricks-delegation"
    
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Databricks Public Subnet
resource "azurerm_subnet" "databricks_public" {
  name                 = "public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_databricks_public_prefix]

  delegation {
    name = "databricks-delegation"
    
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Network Security Group for Databricks
resource "azurerm_network_security_group" "databricks" {
  name                = var.nsg_databricks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# NSG Rules for Databricks
resource "azurerm_network_security_rule" "databricks_worker_to_worker_inbound" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.databricks.name
  description                 = "Required for worker nodes communication within a cluster."
}

resource "azurerm_network_security_rule" "databricks_worker_to_worker_outbound" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.databricks.name
  description                 = "Required for worker nodes communication within a cluster."
}

resource "azurerm_network_security_rule" "databricks_worker_to_webapp" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp"
  priority                    = 101
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443", "3306", "8443-8451"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureDatabricks"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.databricks.name
  description                 = "Required for workers communication with Databricks control plane."
}

resource "azurerm_network_security_rule" "databricks_worker_to_sql" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Sql"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.databricks.name
  description                 = "Required for workers communication with Azure SQL services."
}

resource "azurerm_network_security_rule" "databricks_worker_to_storage" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage"
  priority                    = 103
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Storage"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.databricks.name
  description                 = "Required for workers communication with Azure Storage services."
}

resource "azurerm_network_security_rule" "databricks_worker_to_eventhub" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub"
  priority                    = 104
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9093"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "EventHub"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.databricks.name
  description                 = "Required for worker communication with Azure Eventhub services."
}

# Associate NSG with Databricks Subnets
resource "azurerm_subnet_network_security_group_association" "databricks_private" {
  subnet_id                 = azurerm_subnet.databricks_private.id
  network_security_group_id = azurerm_network_security_group.databricks.id
}

resource "azurerm_subnet_network_security_group_association" "databricks_public" {
  subnet_id                 = azurerm_subnet.databricks_public.id
  network_security_group_id = azurerm_network_security_group.databricks.id
}

# NAT Gateway
resource "azurerm_nat_gateway" "main" {
  name                    = var.nat_gateway_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  tags                    = var.tags
}

# Associate NAT Gateway with Public IP
resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = var.nat_gateway_public_ip_id
}
