#
# Networking configuration for bitbucket
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "bitbucket_eip" {
  tags = {
    Name = "bitbucket_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "bitbucket_eip" {
  instance_id   = "${aws_instance.bitbucket.id}"
  allocation_id = "${aws_eip.bitbucket_eip.id}"
}

resource "aws_route53_record" "bitbucket" {
  zone_id = "${var.zone_id}"
  name    = "bitbucket.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_eip.bitbucket_eip.public_ip}"]
}
