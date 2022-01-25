variable "ibmcloud_api_key" {}

variable "PREFIX" {
  default = "appeng-amq"
}

variable "ssh_key" {}

variable "PRIVATE_IP_PREFIX" {
  default = "10.111"
  description = "prefix for private IP"
}

variable "regions_zones_cidrs" {
  type = map(object({
    region     = string
    zones      = map(string)
    cidr_block = map(string)
  }))

  default = {
    "toronto" = {
      region = "ca-tor"
      zones = {
        "tor1" = "ca-tor-1"
        "tor2" = "ca-tor-2"
        "tor3" = "ca-tor-3"
      }
      cidr_block = {
        "tor1" = "10.111.0.0/18"
        "tor2" = "10.111.64.0/18"
        "tor3" = "10.111.128.0/18"
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
