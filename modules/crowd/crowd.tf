#
# Runs ansible playbook and configure Crowd.
#

variable "inventories_location" {
  default = "."
}

# Render an inventory file to use with the crowd playbook
data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/inventory.tpl")}"

  vars {
    crowd_host = "${aws_eip.crowd.public_ip}"
  }
}

# Create inventory in ${hackathon_location}/hackathon_inventory
resource "null_resource" "crowd_inventory" {
  depends_on = ["aws_instance.crowd"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > ${var.inventories_location}/crowd.inventory"
  }
}
