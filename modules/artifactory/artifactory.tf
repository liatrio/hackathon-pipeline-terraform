#
# Runs ansible playbook and configured Artifactory.
#

variable "inventories_location" {
  default = "."
}

# Render an inventory file to use with the artifactory playbook
data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/inventory.tpl")}"

  vars {
    artifactory_host = "${aws_eip.artifactory.public_ip}"
  }
}

# Create inventory in ${hackathon_location}/hackathon_inventory
resource "null_resource" "artifactory_inventory" {
  depends_on = ["aws_instance.artifactory"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > ${var.inventories_location}/artifactory.inventory"
  }
}
