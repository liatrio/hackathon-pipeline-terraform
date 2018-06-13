#
# Networking configuration for Jenkins Agents
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

resource "aws_route53_record" "docker_nodes" {
  zone_id = "${var.zone_id}"
  count   = "${var.agent_count}"
  name    = "app-${count.index}.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${element(aws_instance.docker_node.*.public_ip, count.index)}"]
}

resource "aws_route53_record" "docker_nodes_wildcard" {
  zone_id = "${var.zone_id}"
  count   = "${var.agent_count}"
  name    = "*.app-${count.index}.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${element(aws_instance.docker_node.*.public_ip, count.index)}"]
}

