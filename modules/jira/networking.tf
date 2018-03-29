#
# Networking configuration for jira
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "jira_eip" {
  tags = {
    Name = "jira_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "jira_eip" {
  instance_id   = "${aws_instance.jira.id}"
  allocation_id = "${aws_eip.jira_eip.id}"
}

resource "aws_route53_record" "jira" {
  zone_id = "${var.zone_id}"
  name    = "jira.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.jira_eip.public_ip}"]
}
