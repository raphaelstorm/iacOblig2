variable "initials" {
  description = "String containing my initials that comes before every resource."
  type        = string
  default     = "rsl"
}

variable "companyname" {
  description = "Name of the company. Used for making prefixes."
  type        = string
  default     = "OpenTerra AS"
}

variable "shortcompanyname" {
  description = "A shorter version of the company name, for use in name prefix."
  type        = string
  default     = "op"
}

variable "defaultlocation" {
  description = "Default location of cloud services."
  type        = string
  default     = "North Europe"
}

variable "billing_accounts" {
  type        = map(string)
  description = "A map containing all billing accounts."
  default = {
    network         = "aaaaaaaaaaaa"
    virtualmachines = "bbbbbbbbbbbb"
    storageaccounts = "cccccccccccc"
  }
}

variable "ip_whitelist" {
  type        = list(string)
  description = "List of all public IP's that is allowed to remotely connect to the network."
  default     = ["88.95.189.158", "89.10.239.169"]
}

variable "vmList" {
  type        = list(map(any))
  description = "A list of maps, where each map is a VM. Keys are size(string), public(bool), username(string), count(number)"
  default = [
    {
      size         = "Standard_DS2_v2"
      public       = true
      username     = "manager"
      computername = "manager"
      count        = 1
    },
    {
      count = 2
    },
  ]
}

variable "default_vm" {
  type        = map(any)
  description = "A map containing the default data for all vm's. VM parameters that are not provided will use these values."
  default = {
    size         = "Standard_D1_v2"
    username     = "openterra"
    computername = "computer"
    public       = false
  }
}

variable "saMap" {
  type        = map(number)
  description = "A map, where each element's key is a storage account kind. The elements value is the amount of such storage accounts that is to be created."
  default = {
    BlobStorage = 2
  }
}
