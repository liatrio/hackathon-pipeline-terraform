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

variable "pipeline_name" {
  default = "hackathon_"
}

variable "tool_name" {
  default = "extra_server"
}

variable "domain" {
  default = "fastfeedback.rocks"
}

variable "inventories_location" {
  default = "."
}

data "aws_route53_zone" "domain" {
  name = "${var.domain}"
}

# Modules
module "artifactory" {
  aws_key_pair  = "${var.aws_key_pair}"
  pipeline_name = "${var.pipeline_name}"
  source        = "./modules/artifactory"
  ssh_sg        = "${aws_security_group.ssh_sg.name}"
  tool_name     = "artifactory"
  zone_id       = "${data.aws_route53_zone.domain.zone_id}"
}

module "jenkins_master" {
  source               = "./modules/jenkins_master"
  aws_key_pair         = "${var.aws_key_pair}"
  tool_name            = "jenkins_master"
  zone_id              = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg               = "${aws_security_group.ssh_sg.name}"
  http_sg              = "${aws_security_group.http_sg.name}"
  jenkins_sg           = "${aws_security_group.jenkins_sg.name}"
  inventories_location = "${var.inventories_location}"
}

module "jenkins_agents" {
  source               = "./modules/jenkins_agents"
  aws_key_pair         = "${var.aws_key_pair}"
  tool_name            = "jenkins_agent"
  zone_id              = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg               = "${aws_security_group.ssh_sg.name}"
  agent_sg             = "${aws_security_group.jenkins_agent.name}"
  agent_count          = "5"
  inventories_location = "${var.inventories_location}"
}

module "bitbucket" {
  source               = "./modules/bitbucket"
  aws_key_pair         = "${var.aws_key_pair}"
  tool_name            = "bitbucket"
  zone_id              = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg               = "${aws_security_group.ssh_sg.name}"
  http_sg              = "${aws_security_group.http_sg.name}"
  inventories_location = "${var.inventories_location}"
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
  source               = "./modules/sonarqube"
  aws_key_pair         = "${var.aws_key_pair}"
  tool_name            = "sonarqube"
  zone_id              = "${data.aws_route53_zone.domain.zone_id}"
  ssh_sg               = "${aws_security_group.ssh_sg.name}"
  http_sg              = "${aws_security_group.http_sg.name}"
  inventories_location = "${var.inventories_location}"
}
