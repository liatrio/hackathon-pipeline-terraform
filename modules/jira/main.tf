#
# Creates Jenkins Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name"    {}
variable "zone_id"      {}

resource "aws_instance" "jira" {
  ami               = "ami-4bf3d731"
  instance_type     = "m5.large"
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

resource "aws_route53_record" "jira" {
  zone_id           = "${var.zone_id}"
  name              = "jira.fastfeedback.rocks"
  type              = "A"
  ttl               = 300
  records           = ["${aws_instance.jira.private_ip}"]
}
