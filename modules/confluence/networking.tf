#
# Networking configuration for confluence
#

variable "zone_id" {}

variable "tool_fqdn" {
  default = "confluence.fastfeedback.rocks"
}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "confluence" {
  tags = {
    Name = "confluence_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "confluence" {
  instance_id   = "${aws_instance.confluence.id}"
  allocation_id = "${aws_eip.confluence.id}"
}

resource "aws_route53_record" "confluence" {
  zone_id = "${var.zone_id}"
  name    = "${var.tool_fqdn}"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.confluence.public_ip}"]
}

resource "aws_route53_health_check" "confluence" {
  fqdn              = "${var.tool_fqdn}"
  port              = 80
  type              = "HTTP"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "confluence_hc${var.pipeline_name}"
  }
}
