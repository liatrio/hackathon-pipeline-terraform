#
# Networking configuration for jenkins
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "jenkins_master_eip" {
  tags = {
    Name = "jenkins_master_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "jenkins_master_eip" {
  instance_id   = "${aws_instance.jenkins_master.id}"
  allocation_id = "${aws_eip.jenkins_master_eip.id}"
}

resource "aws_route53_record" "jenkins_master" {
  zone_id = "${var.zone_id}"
  name    = "jenkins.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.jenkins_master_eip.public_ip}"]
}
