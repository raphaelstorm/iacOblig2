variable "prefix" {
  type        = string
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

variable "ip_whitelist" {
  type        = list(string)
  description = "List of all public IP's that is allowed to remotely connect to the network."
}

variable "addressLayout" {
  type        = map(string)
  description = "A map of strings containing the address space for each subnet, keyed by the subnet's name."
}

variable "vmList" {
  type        = list(map(any))
  description = "A list of maps, where each map is a VM. Keys are size(string), public(bool), username(string), computername(string)"
}