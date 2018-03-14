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

module "jenkins_master" {
  source        = "./modules/jenkins_master"
  aws_key_pair  = "${var.aws_key_pair}"
  tool_name     = "jenkins_master"
}
