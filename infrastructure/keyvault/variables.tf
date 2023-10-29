variable "prefix" {
  description = "Prefix string that comes before every resource created."
}

variable "suffix" {
  description = "The string that comes after every resource name. Usually workspace name."
}

variable "location" {
  type        = string
  description = "Location of cloud service."
}

variable "common_tags" {
  type        = map(string)
  description = "A map containing billing account, responsible person, and the full company name."
}

variable "sa_info" {
  type        = list(map(string))
  description = "A list of storage accounts, where each map has element for name and id."
}

variable "sa_name" {
  type        = string
  description = "The name of the storage account"
}