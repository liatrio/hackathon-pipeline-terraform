#
# Creates Jenkins Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name"    {}
variable "agent_count" { 
  default = 2 
}

resource "aws_instance" "jenkins_agent" {
  ami               = "ami-4bf3d731"
  instance_type     = "t2.large"
  key_name          = "${var.aws_key_pair}"
  count             = "${var.agent_count}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "200"
  }

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}

