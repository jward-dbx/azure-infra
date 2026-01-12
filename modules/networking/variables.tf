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
