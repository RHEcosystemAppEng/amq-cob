
data "ibm_is_ssh_key" "ssh_key_sg_mac" {
  name = var.ssh_key
}

data "ibm_is_image" "redhat_8_min" {
  name = "ibm-redhat-8-4-minimal-amd64-1"
}
