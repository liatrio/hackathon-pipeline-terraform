#
# Runs ansible playbook and configured Sonarqube.
#

variable "inventories_location" {
  default = "."
}

# Render an inventory file to use with the jenkins playbook
data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/inventory.tpl")}"

  vars {
    sonarqube_host = "${aws_eip.sonarqube.public_ip}"
  }
}

# Create inventory in ${hackathon_location}/hackathon_inventory
resource "null_resource" "sonarqube_inventory" {
  depends_on = ["aws_instance.sonarqube"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > ${var.inventories_location}/sonarqube.inventory"
  }
}
