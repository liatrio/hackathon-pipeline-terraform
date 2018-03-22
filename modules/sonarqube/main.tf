#
# Creates Sonarqube Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name" {}
variable "zone_id" {}
variable "ssh_sg" {}

data "aws_ebs_volume" "sonar_volume" {
  filter {
    name   = "tag:Name"
    values = ["sonar_data"]
  }

  most_recent = true
}

resource "aws_instance" "sonarqube" {
  ami               = "ami-1853ac65"
  instance_type     = "t2.large"
  key_name          = "${var.aws_key_pair}"
  security_groups   = ["${var.ssh_sg}"]
  availability_zone = "us-east-1a"

  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}

resource "aws_volume_attachment" "sonar_data" {
  device_name = "/dev/sdh"
  volume_id   = "${data.aws_ebs_volume.sonar_volume.volume_id}"
  instance_id = "${aws_instance.sonarqube.id}"
}

resource "aws_route53_record" "sonarqube" {
  zone_id = "${var.zone_id}"
  name    = "sonarqube.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.sonarqube.public_ip}"]
}
