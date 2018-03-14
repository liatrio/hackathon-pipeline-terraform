#
# Creates Jenkins Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name"    {}
variable "zone_id"      {}

resource "aws_instance" "jenkins_master" {
  ami               = "ami-4bf3d731"
  instance_type     = "t2.micro"
  key_name          = "${var.aws_key_pair}"

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}

resource "aws_route53_record" "jenkins" {
  zone_id           = "${var.zone_id}"
  name              = "jenkins.fastfeedback.rocks"
  type              = "A"
  ttl               = 300
  records           = ["${aws_instance.jenkins_master.private_ip}"]
}
