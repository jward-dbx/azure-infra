# General Configuration
variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Networking Configuration
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnet_default_prefix" {
  description = "Address prefix for default subnet"
  type        = string
}

variable "subnet_sql_private_endpoints_prefix" {
  description = "Address prefix for SQL private endpoints subnet"
  type        = string
}

variable "subnet_databricks_private_prefix" {
  description = "Address prefix for Databricks private subnet"
  type        = string
}

variable "subnet_databricks_public_prefix" {
  description = "Address prefix for Databricks public subnet"
  type        = string
}

variable "nsg_databricks_name" {
  description = "Name of the Network Security Group for Databricks"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  type        = string
}

variable "nat_gateway_public_ip_id" {
  description = "Resource ID of the public IP for NAT Gateway"
  type        = string
}

# Databricks Configuration
variable "databricks_workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

variable "databricks_sku" {
  description = "SKU for Databricks workspace (standard, premium, trial)"
  type        = string
}

variable "databricks_managed_resource_group_name" {
  description = "Name of the managed resource group for Databricks"
  type        = string
}

variable "databricks_access_connector_name" {
  description = "Name of the Databricks Access Connector"
  type        = string
}

variable "databricks_no_public_ip" {
  description = "Enable no public IP for Databricks workspace"
  type        = bool
}

variable "databricks_public_network_access_enabled" {
  description = "Enable public network access for Databricks workspace"
  type        = bool
}

# SQL Server Configuration
variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "sql_server_version" {
  description = "Version of SQL Server"
  type        = string
}

variable "sql_admin_login" {
  description = "Administrator login for SQL Server"
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "Administrator password for SQL Server"
  type        = string
  sensitive   = true
}

variable "sql_min_tls_version" {
  description = "Minimum TLS version for SQL Server"
  type        = string
}

variable "sql_public_network_access_enabled" {
  description = "Enable public network access for SQL Server"
  type        = bool
}

variable "sql_azuread_admin_login" {
  description = "Azure AD administrator login username"
  type        = string
}

variable "sql_azuread_admin_object_id" {
  description = "Azure AD administrator object ID"
  type        = string
}

variable "sql_azuread_admin_tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "sql_databases" {
  description = "Map of SQL databases to create"
  type = map(object({
    name         = string
    sku_name     = string
    max_size_gb  = number
    min_capacity = number
    collation    = string
  }))
}

variable "sql_private_endpoint_name" {
  description = "Name of the SQL Server private endpoint"
  type        = string
}

# Storage Configuration
variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "storage_account_tier" {
  description = "Performance tier of the storage account"
  type        = string
}

variable "storage_account_replication_type" {
  description = "Replication type for the storage account"
  type        = string
}

variable "storage_enable_hns" {
  description = "Enable hierarchical namespace (Data Lake Gen2)"
  type        = bool
}

variable "storage_enable_large_file_share" {
  description = "Enable large file share"
  type        = bool
}
