#
# Networking configuration for confluence
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "confluence_eip" {
  tags = {
    Name = "confluence_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "confluence_eip" {
  instance_id   = "${aws_instance.confluence.id}"
  allocation_id = "${aws_eip.confluence_eip.id}"
}

resource "aws_route53_record" "confluence" {
  zone_id = "${var.zone_id}"
  name    = "confluence.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.confluence_eip.public_ip}"]
}
