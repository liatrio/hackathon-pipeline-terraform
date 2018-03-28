#
# Preps ansible inventory and configured Jira.
#

variable "inventories_location" {
  default = "."
}

# Render an inventory file to use with the jira playbook
data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/inventory.tpl")}"

  vars {
    jira_host = "${aws_instance.jira.public_ip}"
  }
}

# Create inventory in ${hackathon_location}/hackathon_inventory
resource "null_resource" "jira_inventory" {
  depends_on = ["aws_instance.jira"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > ${var.inventories_location}/jira.inventory"
  }
}
