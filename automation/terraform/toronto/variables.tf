variable "ibmcloud_api_key" {}

variable "PREFIX" {
  default = "PROVIDE_VALUE_ON_CLI"
}

variable "ssh_key" {}

variable "REGION" {
  default = "ca-tor"
}

# This variable should be defined on the cli
variable "CLUSTER1_PRIVATE_IP_PREFIX" {
#  default = "10.70"
}

# This variable should be defined on the cli
variable "CLUSTER2_PRIVATE_IP_PREFIX" {
#  default = "10.71"
}

variable "tags" {
  type        = list(any)
  default     = [
    "jira:appeng-94",
    "dev:appeng-amq_cob_team",
    "created_by:terraform"
  ]
  description = "provides tags for all the resources crated here"
}
