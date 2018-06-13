#
# Creates Jenkins Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name" {}
variable "ssh_sg" {}
variable "http_sg" {}
variable "https_sg" {}

variable "agent_count" {
  default = 5
}

resource "aws_instance" "docker_node" {
  ami             = "ami-1853ac65"
  instance_type   = "t2.medium"
  key_name        = "${var.aws_key_pair}"
  count           = "${var.agent_count}"
  security_groups = ["${var.ssh_sg}", "${var.http_sg}", "${var.https_sg}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = "200"
  }

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}
