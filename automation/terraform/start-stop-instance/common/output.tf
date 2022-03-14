
output "instance_info" {
  value = {
    for instance in data.ibm_is_instance.instance:
      instance.id => "${instance.status} <- ${instance.name}"
  }
  description = "The instance names"
}

output "instance_action_info" {
  value = {
    for action in ibm_is_instance_action.instance_action:
      action.instance => "${action.status} -> (action=${var.INSTANCE_ACTION}, force_action=${var.FORCE_ACTION})"
  }
  description = "The instance names"
}
