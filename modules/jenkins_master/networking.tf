#
# Networking configuration for jenkins
#

variable "zone_id" {}

variable "tool_fqdn" {
  default = "jenkins.fastfeedback.rocks"
}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "jenkins_master" {
  tags = {
    Name = "jenkins_master_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "jenkins_master" {
  instance_id   = "${aws_instance.jenkins_master.id}"
  allocation_id = "${aws_eip.jenkins_master.id}"
}

resource "aws_route53_record" "jenkins_master" {
  zone_id = "${var.zone_id}"
  name    = "${var.tool_fqdn}"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.jenkins_master.public_ip}"]
}

resource "aws_route53_health_check" "jenkins_master" {
  fqdn              = "${var.tool_fqdn}"
  port              = 80
  type              = "HTTP"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "jenkins_master_hc${var.pipeline_name}"
  }
}
