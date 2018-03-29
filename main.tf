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
  default = "_hackathon"
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
  source        = "./modules/artifactory"
  aws_key_pair  = "${var.aws_key_pair}"
  pipeline_name = "${var.pipeline_name}"
  ssh_sg        = "${aws_security_group.ssh_sg.name}"
  tool_name     = "artifactory"
  zone_id       = "${data.aws_route53_zone.domain.zone_id}"
}

module "bitbucket" {
  source               = "./modules/bitbucket"
  aws_key_pair         = "${var.aws_key_pair}"
  http_sg              = "${aws_security_group.http_sg.name}"
  inventories_location = "${var.inventories_location}"
  pipeline_name        = "${var.pipeline_name}"
  ssh_sg               = "${aws_security_group.ssh_sg.name}"
  tool_name            = "bitbucket"
  zone_id              = "${data.aws_route53_zone.domain.zone_id}"
}

module "confluence" {
  source        = "./modules/confluence"
  aws_key_pair  = "${var.aws_key_pair}"
  pipeline_name = "${var.pipeline_name}"
  ssh_sg        = "${aws_security_group.ssh_sg.name}"
  tool_name     = "confluence"
  zone_id       = "${data.aws_route53_zone.domain.zone_id}"
}

module "jenkins_agents" {
  source               = "./modules/jenkins_agents"
  agent_count          = "5"
  agent_sg             = "${aws_security_group.jenkins_agent.name}"
  aws_key_pair         = "${var.aws_key_pair}"
  inventories_location = "${var.inventories_location}"
  pipeline_name        = "${var.pipeline_name}"
  ssh_sg               = "${aws_security_group.ssh_sg.name}"
  tool_name            = "jenkins_agent"
  zone_id              = "${data.aws_route53_zone.domain.zone_id}"
}

module "jenkins_master" {
  source               = "./modules/jenkins_master"
  aws_key_pair         = "${var.aws_key_pair}"
  http_sg              = "${aws_security_group.http_sg.name}"
  inventories_location = "${var.inventories_location}"
  jenkins_sg           = "${aws_security_group.jenkins_sg.name}"
  pipeline_name        = "${var.pipeline_name}"
  ssh_sg               = "${aws_security_group.ssh_sg.name}"
  tool_name            = "jenkins_master"
  zone_id              = "${data.aws_route53_zone.domain.zone_id}"
}

module "jira" {
  source        = "./modules/jira"
  aws_key_pair  = "${var.aws_key_pair}"
  pipeline_name = "${var.pipeline_name}"
  ssh_sg        = "${aws_security_group.ssh_sg.name}"
  tool_name     = "jira"
  zone_id       = "${data.aws_route53_zone.domain.zone_id}"
}

module "sonarqube" {
  source               = "./modules/sonarqube"
  aws_key_pair         = "${var.aws_key_pair}"
  http_sg              = "${aws_security_group.http_sg.name}"
  inventories_location = "${var.inventories_location}"
  pipeline_name        = "${var.pipeline_name}"
  ssh_sg               = "${aws_security_group.ssh_sg.name}"
  tool_name            = "sonarqube"
  zone_id              = "${data.aws_route53_zone.domain.zone_id}"
}
