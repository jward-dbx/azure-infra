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

variable "workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

variable "sku" {
  description = "SKU for Databricks workspace (standard, premium, trial)"
  type        = string
  default     = "premium"
}

variable "managed_resource_group_name" {
  description = "Name of the managed resource group for Databricks"
  type        = string
}

variable "access_connector_name" {
  description = "Name of the Databricks Access Connector"
  type        = string
}

variable "no_public_ip" {
  description = "Enable no public IP for Databricks workspace"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access for Databricks workspace"
  type        = bool
  default     = true
}

variable "virtual_network_id" {
  description = "ID of the virtual network for VNet injection"
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private subnet for Databricks"
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the public subnet for Databricks"
  type        = string
}

variable "private_subnet_nsg_association_id" {
  description = "ID of the NSG association for the private subnet"
  type        = string
}

variable "public_subnet_nsg_association_id" {
  description = "ID of the NSG association for the public subnet"
  type        = string
}
