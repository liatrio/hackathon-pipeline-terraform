#
# Networking configuration for sonarqube
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "sonarqube_eip" {
  tags = {
    Name = "sonarqube_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "sonarqube_eip" {
  instance_id   = "${aws_instance.sonarqube.id}"
  allocation_id = "${aws_eip.sonarqube_eip.id}"
}

resource "aws_route53_record" "sonarqube" {
  zone_id = "${var.zone_id}"
  name    = "sonarqube.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.sonarqube_eip.public_ip}"]
}
