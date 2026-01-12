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

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique, 3-24 lowercase alphanumeric characters)"
  type        = string
}

variable "account_tier" {
  description = "Performance tier of the storage account (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type for the storage account (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "LRS"
}

variable "enable_hns" {
  description = "Enable hierarchical namespace (Data Lake Gen2)"
  type        = bool
  default     = true
}

variable "enable_large_file_share" {
  description = "Enable large file share (up to 100 TiB)"
  type        = bool
  default     = true
}
