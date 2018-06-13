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
    docker_node_1 = "${aws_instance.docker_node.0.public_ip}"
    docker_node_2 = "${aws_instance.docker_node.1.public_ip}"
    docker_node_3 = "${aws_instance.docker_node.2.public_ip}"
    docker_node_4 = "${aws_instance.docker_node.3.public_ip}"
    docker_node_5 = "${aws_instance.docker_node.4.public_ip}"
  }
}

# Create inventory in ${hackathon_location}/hackathon_inventory
resource "null_resource" "docker_nodes_inventory" {
  depends_on = ["aws_route53_record.docker_nodes"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > ${var.inventories_location}/docker_nodes.inventory"
  }
}

