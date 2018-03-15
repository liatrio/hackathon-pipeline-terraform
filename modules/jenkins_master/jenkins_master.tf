
# Runs ansible playbook and configured Jenkins.
#

resource "null_resource" "run_base_playbook" {

  depends_on = ["aws_instance.jenkins_master"]

  connection {
    type         = "ssh"
    user         = "ec2-user"
    host         = "${aws_instance.jenkins_master.public_ip}"
    agent        = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y epel-release ansible git httpd-tools java-1.8.0-openjdk-headless",
      "ansible-galaxy install geerlingguy.jenkins"
    ]
  }

  # Copy inventory to bastion
  provisioner "file" {
    content     = "inventory.tpl"
    destination = "/home/ec2-user/inventory"
  }

  # Run the playbook
  provisioner "remote-exec" {
    inline = [
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/ec2-user/inventory playbook.yml",
      "rm /home/ec2-user/inventory",
    ]
  }
}
