#
# Creates Jenkins Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name"    {}

resource "aws_instance" "jenkins_master" {
  ami               = "ami-4bf3d731"
  instance_type     = "t2.micro"
  key_name          = "${var.aws_key_pair}"

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}
