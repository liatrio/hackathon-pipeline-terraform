#
# Networking configuration for Artifactory
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "artifactory_eip" {
  tags = {
    Name = "artifactory_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "artifactory_eip" {
  instance_id   = "${aws_instance.artifactory.id}"
  allocation_id = "${aws_eip.artifactory_eip.id}"
}

resource "aws_route53_record" "artifactory" {
  zone_id = "${var.zone_id}"
  name    = "artifactory.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.artifactory_eip.public_ip}"]
}
