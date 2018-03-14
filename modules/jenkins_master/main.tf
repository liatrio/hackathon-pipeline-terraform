#
# Creates Jenkins Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name"    {}

resource "aws_instance" "jenkins_master" {
  ami               = "ami-4bf3d731"
  instance_type     = "t2.micro"
  key_name          = "${var.aws_key_pair}"

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}

data "aws_route53_zone" "domain" {
  name = "fastfeedback.rocks"
}

resource "aws_route53_record" "jenkins" {
  zone_id           = "${data.aws_route53_zone.domain.zone_id}"
  name              = "jenkins.fastfeedback.rocks"
  type              = "A"
  ttl               = 300
  records           = ["${aws_instance.jenkins_master.private_ip}"]
}
