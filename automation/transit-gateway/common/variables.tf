variable "ibmcloud_api_key" {}

variable "GATEWAY_NAME" {}

variable "GATEWAY_REGION" {}

variable "VPC_1" {}

variable "VPC_2" {}

variable "NETWORK_TYPE" {}

variable "GLOBAL" {
  description = "Boolean value indicating whether the transit gateway is global or not"
  type = bool
}

variable "tags" {}
