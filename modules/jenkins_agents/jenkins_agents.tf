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
    jenkins_agent_1 = "${aws_eip.jenkins_agent_eip.0.public_ip}"
    jenkins_agent_2 = "${aws_eip.jenkins_agent_eip.1.public_ip}"
    jenkins_agent_3 = "${aws_eip.jenkins_agent_eip.2.public_ip}"
    jenkins_agent_4 = "${aws_eip.jenkins_agent_eip.3.public_ip}"
    jenkins_agent_5 = "${aws_eip.jenkins_agent_eip.4.public_ip}"
  }
}

# Create inventory in ${hackathon_location}/hackathon_inventory
resource "null_resource" "jenkins_inventory" {
  depends_on = ["aws_route53_record.jenkins_agents"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > ${var.inventories_location}/jenkins_agents.inventory"
  }
}
