variable "ibmcloud_api_key" {}
variable "PREFIX" {}

variable "REGION_1" {
  default = "ca-tor"
}

variable "REGION_2" {
  default = "us-south"
}

variable "INSTANCE_ACTION" {}

variable "FORCE_ACTION" {}

variable "INSTANCE_NAMES" {
  description = "Names of the instances that need to be stopped or started and doesn't include NFS server"
  type        = list(string)
  default     = [
    "broker01-live1", "broker02-bak1", "broker03-live2", "broker04-bak2",
    "broker05-live3", "broker06-bak3", "broker07-live4", "broker08-bak4",
    "hub-router1", "spoke-router2", "spoke-router3"
  ]
}

