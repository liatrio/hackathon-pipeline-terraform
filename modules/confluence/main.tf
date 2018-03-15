#
# Creates Jenkins Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name"    {}
variable "zone_id"      {}

resource "aws_instance" "confluence" {
  ami               = "ami-4bf3d731"
  instance_type     = "t2.large"
  key_name          = "${var.aws_key_pair}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "500"
  }

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}

resource "aws_route53_record" "confluence" {
  zone_id           = "${var.zone_id}"
  name              = "tool_name.fastfeedback.rocks"
  type              = "A"
  ttl               = 300
  records           = ["${aws_instance.confluence.private_ip}"]
}
