#
# Networking configuration for bitbucket
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

variable "tool_fqdn" {
  default = "bitbucket.fastfeedback.rocks"
}

resource "aws_eip" "bitbucket" {
  tags = {
    Name = "bitbucket_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "bitbucket" {
  instance_id   = "${aws_instance.bitbucket.id}"
  allocation_id = "${aws_eip.bitbucket.id}"
}

resource "aws_route53_record" "bitbucket" {
  zone_id = "${var.zone_id}"
  name    = "bitbucket.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.bitbucket.public_ip}"]
}

resource "aws_route53_health_check" "bitbucket" {
  fqdn              = "${var.tool_fqdn}"
  port              = 80
  type              = "HTTP"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "bitbucket_hc${var.pipeline_name}"
  }
}
