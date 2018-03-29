#
# Creates Jenkins Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name" {}
variable "ssh_sg" {}
variable "agent_sg" {}

variable "agent_count" {
  default = 5
}

resource "aws_instance" "jenkins_agent" {
  ami             = "ami-1853ac65"
  instance_type   = "t2.large"
  key_name        = "${var.aws_key_pair}"
  count           = "${var.agent_count}"
  security_groups = ["${var.ssh_sg}", "${var.agent_sg}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = "200"
  }

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}
