# Runs ansible playbook and configured Jenkins.
#

# Render an inventory file to use with the jenkins playbook
data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/inventory.tpl")}"

  vars {
    jenkins_master_host = "${aws_instance.jenkins_master.public_ip}"
  }
}

resource "null_resource" "jenkins_inventory" {
  depends_on = ["aws_instance.jenkins_master"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > ${path.module}/inventory"
  }
}

resource "null_resource" "run_base_playbook" {
  depends_on = ["null_resource.jenkins_inventory"]

  # Run the playbook
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${path.module}/inventory ./modules/jenkins_master/playbook.yml"
  }
}
