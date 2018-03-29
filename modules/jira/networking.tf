#
# Networking configuration for jira
#

variable "zone_id" {}

variable "tool_fqdn" {
  default = "jira.fastfeedback.rocks"
}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "jira" {
  tags = {
    Name = "jira_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "jira" {
  instance_id   = "${aws_instance.jira.id}"
  allocation_id = "${aws_eip.jira.id}"
}

resource "aws_route53_record" "jira" {
  zone_id = "${var.zone_id}"
  name    = "jira.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.jira.public_ip}"]
}

resource "aws_route53_health_check" "jira" {
  ip_address        = "${aws_eip.jira.public_ip}"
  port              = 80
  type              = "HTTP"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "jira_hc${var.pipeline_name}"
  }
}
