#
# Runs ansible playbook and configured Sonarqube.
#

variable "inventories_location" {
  default = "."
}

# Render an inventory file to use with the bitbucket playbook
data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/inventory.tpl")}"

  vars {
    bitbucket_host = "${aws_instance.bitbucket.public_ip}"
  }
}

# Create inventory in ${hackathon_location}/hackathon_inventory
resource "null_resource" "bitbucket_inventory" {
  depends_on = ["aws_instance.bitbucket"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > ${var.inventories_location}/bitbucket.inventory"
  }
}
