#
# Runs ansible playbook and configured Jenkins.
#

variable "inventories_location" {
  default = "."
}

# Render an inventory file to use with the jenkins playbook
data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/inventory.tpl")}"

  vars {
    jenkins_master_host = "${aws_eip.jenkins_master_eip.public_ip}"
  }
}

# Create inventory in ${hackathon_location}/hackathon_inventory
resource "null_resource" "jenkins_inventory" {
  depends_on = ["aws_instance.jenkins_master"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > ${var.inventories_location}/jenkins_master.inventory"
  }
}
