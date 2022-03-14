locals {
  # Add the nfs servers to the list of instance names (for region 1)
  region_1_instance_names = concat([
      "${var.REGION_1}-1-nfs-server-01",
      "${var.REGION_1}-2-nfs-server-02"
    ],
    var.INSTANCE_NAMES
  )

  # Add the nfs servers to the list of instance names (for region 2)
  region_2_instance_names = concat([
      "${var.REGION_2}-1-nfs-server-01",
      "${var.REGION_2}-2-nfs-server-02"
    ],
    var.INSTANCE_NAMES
  )
}