#
# Networking configuration for crowd
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

variable "tool_fqdn" {
  default = "crowd.fastfeedback.rocks"
}

resource "aws_eip" "crowd" {
  tags = {
    Name = "crowd_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "crowd" {
  instance_id   = "${aws_instance.crowd.id}"
  allocation_id = "${aws_eip.crowd.id}"
}

resource "aws_route53_record" "crowd" {
  zone_id = "${var.zone_id}"
  name    = "${var.tool_fqdn}"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.crowd.public_ip}"]
}

resource "aws_route53_health_check" "crowd" {
  ip_address        = "${aws_eip.crowd.public_ip}"
  port              = 80
  type              = "HTTP"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "crowd_hc${var.pipeline_name}"
  }
}
