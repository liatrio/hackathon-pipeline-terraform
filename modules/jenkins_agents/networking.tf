#
# Networking configuration for Jenkins Agents
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

resource "aws_route53_record" "jenkins_agents" {
  zone_id = "${var.zone_id}"
  count   = "${var.agent_count}"
  name    = "jenkins-${count.index}.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${element(aws_instance.jenkins_agent.*.private_ip, count.index)}"]
}
