variable "ibmcloud_api_key" {}

variable "PREFIX" {
  default = "appeng-amq"
}

variable "ssh_key" {}

variable "toronto_regions_zones" {
  type = object({
    region = string
    zones  = map(string)
  })

  default = {
    region = "ca-tor"
    zones  = {
      "tor1" = "ca-tor-1"
      "tor2" = "ca-tor-2"
      "tor3" = "ca-tor-3"
    }
  }
}

variable "dallas_regions_zones" {
  type = object({
    region = string
    zones  = map(string)
  })

  default = {
    region = "us-south"
    zones  = {
      "dal1" = "us-south-1"
      "dal2" = "us-south-2"
      "dal3" = "us-south-3"
    }
  }
}

variable "tags" {
  type        = list(any)
  default     = [
    "jira:appeng-100",
    "dev:appeng-amq_cob_team",
    "type:interconnect"
  ]
  description = "provides tags for all the resources crated here"
}
