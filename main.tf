terraform {
    backend "s3" {
        bucket  = "hackathon-pipeline-tfstates"
        key     = "state/hackathon-pipeline-terraform.tfstate"
        region  = "us-east-1"
    }
}

provider "aws" {
  region  = "us-east-1"
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

module "jenkins_master" {
  source       = "./modules/jenkins_master"
  aws_key_pair = "${var.aws_key_pair}"
  tool_name    = "jenkins_master"
  zone_id      = "${data.aws_route53_zone.domain.zone_id}"
}

module "jenkins_agents" {
  source        = "./modules/jenkins_agents"
  aws_key_pair  = "${var.aws_key_pair}"
  tool_name     = "jenkins_agent"
}

module "bitbucket" {
  source        = "./modules/bitbucket"
  aws_key_pair  = "${var.aws_key_pair}"
  tool_name     = "bitbucket"
  zone_id       = "${data.aws_route53_zone.domain.zone_id}"
}

module "jira" {
  source        = "./modules/jira"
  aws_key_pair  = "${var.aws_key_pair}"
  tool_name     = "jira"
  zone_id      = "${data.aws_route53_zone.domain.zone_id}"
}

module "confluence" {
  source       = "./modules/confluence"
  aws_key_pair = "${var.aws_key_pair}"
  tool_name    = "confluence"
  zone_id      = "${data.aws_route53_zone.domain.zone_id}"
}
