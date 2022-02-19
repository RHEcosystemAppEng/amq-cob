variable "ibmcloud_api_key" {}

variable "PREFIX" {
  default = "appeng-amq"
}

variable "ssh_key" {}

variable "REGION_1" {
  default = "ca-tor"
}

variable "REGION_2" {
  default = "us-south"
}

variable "tags" {
  type        = list(any)
  default     = [
    "jira:appeng-94",
    "dev:appeng-amq_cob_team",
    "type:interconnect",
    "created_by:terraform"
  ]
  description = "provides tags for all the resources crated here"
}
