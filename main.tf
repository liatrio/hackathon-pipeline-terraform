terraform {
  backend "s3" {
    bucket = "hackathon-pipeline-tfstates"
    key    = "state/hackathon-pipeline-terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "aws_key_pair" {
  default = "hackathon_pipeline"
}

variable "tool_name" {
  default = "extra_server"
}

variable "domain" {
  default = "fastfeedback.rocks"
}

data "aws_route53_zone" "domain" {
  name = "${var.domain}"
}

resource "aws_security_group" "ssh_sg" {
  name        = "allow_ssh"
  description = "All SSH traffic"

  tags {
    Project = "hackathon_pipeline"
    Name    = "hackathon_sg_ssh"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "jenkins_master" {
  source       = "./modules/jenkins_master"
  aws_key_pair = "${var.aws_key_pair}"
  tool_name    = "jenkins_master"
  zone_id      = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg       = "${aws_security_group.ssh_sg.name}"
}

module "jenkins_agents" {
  source       = "./modules/jenkins_agents"
  aws_key_pair = "${var.aws_key_pair}"
  tool_name    = "jenkins_agent"
  ssh_sg       = "${aws_security_group.ssh_sg.name}"
}

module "bitbucket" {
  source       = "./modules/bitbucket"
  aws_key_pair = "${var.aws_key_pair}"
  tool_name    = "bitbucket"
  zone_id      = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg       = "${aws_security_group.ssh_sg.name}"
}

module "jira" {
  source       = "./modules/jira"
  aws_key_pair = "${var.aws_key_pair}"
  tool_name    = "jira"
  zone_id      = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg       = "${aws_security_group.ssh_sg.name}"
}

module "confluence" {
  source       = "./modules/confluence"
  aws_key_pair = "${var.aws_key_pair}"
  tool_name    = "confluence"
  zone_id      = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg       = "${aws_security_group.ssh_sg.name}"
}

module "sonarqube" {
  source       = "./modules/sonarqube"
  aws_key_pair = "${var.aws_key_pair}"
  tool_name    = "sonarqube"
  zone_id      = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg       = "${aws_security_group.ssh_sg.name}"
}

module "artifactory" {
  source       = "./modules/artifactory"
  aws_key_pair = "${var.aws_key_pair}"
  tool_name    = "artifactory"
  zone_id      = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg       = "${aws_security_group.ssh_sg.name}"
}
