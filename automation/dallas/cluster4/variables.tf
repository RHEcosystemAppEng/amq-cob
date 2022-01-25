variable "ibmcloud_api_key" {}

variable "PREFIX" {
  default = "appeng-amq"
}

variable "ssh_key" {}

variable "PRIVATE_IP_PREFIX" {
  default = "10.210"
  description = "prefix for private IP"
}

variable "regions_zones_cidrs" {
  type = map(object({
    region     = string
    zones      = map(string)
    cidr_block = map(string)
  }))

  default = {
    dallas = {
      region = "us-south"
      zones = {
        dal1 : "us-south-1"
        dal2 : "us-south-2"
        dal3 : "us-south-3"
      }
      cidr_block : {
        dal1 : "10.210.0.0/18"
        dal2 : "10.210.64.0/18"
        dal3 : "10.210.128.0/18"
      }
    }
  }
}

variable "tags" {
  type = list(any)
  default = [
    "jira:appeng-100",
    "dev:appeng-amq_cob_team"
  ]
  description = "provides tags for all the resources crated here"
}
