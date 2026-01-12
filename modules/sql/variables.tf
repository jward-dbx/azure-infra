variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "server_version" {
  description = "Version of SQL Server"
  type        = string
  default     = "12.0"
}

variable "admin_login" {
  description = "Administrator login for SQL Server"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Administrator password for SQL Server"
  type        = string
  sensitive   = true
}

variable "min_tls_version" {
  description = "Minimum TLS version for SQL Server"
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "Enable public network access for SQL Server"
  type        = bool
  default     = true
}

variable "azuread_admin_login" {
  description = "Azure AD administrator login username"
  type        = string
}

variable "azuread_admin_object_id" {
  description = "Azure AD administrator object ID"
  type        = string
}

variable "azuread_admin_tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "databases" {
  description = "Map of SQL databases to create"
  type = map(object({
    name         = string
    sku_name     = string
    max_size_gb  = number
    min_capacity = number
    collation    = string
  }))
  default = {}
}

variable "private_endpoint_name" {
  description = "Name of the SQL Server private endpoint"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the private endpoint"
  type        = string
}
