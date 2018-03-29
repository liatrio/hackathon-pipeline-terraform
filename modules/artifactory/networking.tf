#
# Networking configuration for Artifactory
#

variable "zone_id" {}

variable "tool_fqdn" {
  default = "artifactory.fastfeedback.rocks"
}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "artifactory" {
  tags = {
    Name = "artifactory_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "artifactory" {
  instance_id   = "${aws_instance.artifactory.id}"
  allocation_id = "${aws_eip.artifactory.id}"
}

resource "aws_route53_record" "artifactory" {
  zone_id = "${var.zone_id}"
  name    = "${var.tool_fqdn}"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.artifactory.public_ip}"]
}

resource "aws_route53_health_check" "artifactory" {
  fqdn              = "${var.tool_fqdn}"
  port              = 80
  type              = "HTTP"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "artifactory_hc${var.pipeline_name}"
  }
}
