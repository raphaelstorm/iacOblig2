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

variable "public_ip_list" {
  type        = list(string)
  description = "A list of public ip's supplied by the network module."
}

variable "subnet" {
  type        = string
  description = "The id of the VM subnet."
}

variable "vm_password" {
  type        = string
  description = "The default password used for all created vm's."
}

variable "vmList" {
  type        = list(map(any))
  description = "A list of maps, where each map is a VM. Keys are size(string), public(bool), username(string), computername(string)"
}