#
# Networking configuration for Jenkins Agents
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

resource "aws_eip" "jenkins_agent_eip" {
  count = "${var.agent_count}"

  tags = {
    Name = "jenkins_agent_${count.index}_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "jenkins_agents_eip" {
  instance_id   = "${element(aws_instance.jenkins_agent.*.id, count.index)}"
  allocation_id = "${element(aws_eip.jenkins_agent_eip.*.id, count.index)}"
}

resource "aws_route53_record" "jenkins_agents" {
  zone_id = "${var.zone_id}"
  count   = "${var.agent_count}"
  name    = "jenkins-${count.index}.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${element(aws_eip.jenkins_agent_eip.*.public_ip, count.index)}"]
}
