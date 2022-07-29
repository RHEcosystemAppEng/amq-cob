data "ibm_is_instance" "instance" {
  for_each = toset(var.INSTANCE_NAMES)
  name     = "${var.PREFIX}-${each.value}"
  provider = ibm
}

resource "ibm_is_instance_action" "instance_action" {
  for_each     = toset(var.INSTANCE_NAMES)
  action       = var.INSTANCE_ACTION
  force_action = var.FORCE_ACTION
  instance     = data.ibm_is_instance.instance[each.key].id
}
