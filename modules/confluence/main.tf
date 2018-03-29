#
# Creates Confluence Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name" {}
variable "ssh_sg" {}

data "aws_ebs_volume" "confluence_volume" {
  filter {
    name   = "tag:Name"
    values = ["confluence_data"]
  }

  most_recent = true
}

resource "aws_instance" "confluence" {
  ami               = "ami-1853ac65"
  instance_type     = "t2.large"
  key_name          = "${var.aws_key_pair}"
  security_groups   = ["${var.ssh_sg}"]
  availability_zone = "us-east-1a"

  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}

resource "aws_volume_attachment" "confluence_data" {
  device_name  = "/dev/sdh"
  volume_id    = "${data.aws_ebs_volume.confluence_volume.volume_id}"
  instance_id  = "${aws_instance.confluence.id}"
  skip_destroy = true
}
