#
# Networking configuration for sonarqube
#

variable "zone_id" {}

variable "tool_fqdn" {
  default = "jira.fastfeedback.rocks"
}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "sonarqube" {
  tags = {
    Name = "sonarqube_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "sonarqube" {
  instance_id   = "${aws_instance.sonarqube.id}"
  allocation_id = "${aws_eip.sonarqube.id}"
}

resource "aws_route53_record" "sonarqube" {
  zone_id = "${var.zone_id}"
  name    = "sonarqube.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.sonarqube.public_ip}"]
}

resource "aws_route53_health_check" "sonarqube" {
  fqdn              = "${var.tool_fqdn}"
  port              = 80
  type              = "HTTP"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "sonarqube_hc${var.pipeline_name}"
  }
}
