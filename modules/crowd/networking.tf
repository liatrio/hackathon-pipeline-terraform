#
# Networking configuration for crowd
#

variable "zone_id" {}

variable "pipeline_name" {
  default = ""
}

variable "tool_fqdn" {
  default = "crowd.fastfeedback.rocks"
}

resource "aws_eip" "crowd" {
  tags = {
    Name = "crowd_eip${var.pipeline_name}"
  }
}

resource "aws_eip_association" "crowd" {
  instance_id   = "${aws_instance.crowd.id}"
  allocation_id = "${aws_eip.crowd.id}"
}

resource "aws_route53_record" "crowd-primary" {
  zone_id = "${var.zone_id}"
  name    = "${var.tool_fqdn}"
  type    = "A"
  ttl     = 60
  records = ["${aws_eip.crowd.public_ip}"]
  set_identifier = "crowd-Primary"
  health_check_id = "${aws_route53_health_check.crowd.id}"
  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "crowd-secondary" {
  zone_id = "${var.zone_id}"
  name    = "${var.tool_fqdn}"
  type    = "A"
  alias {
    name                   = "${var.maint_distribution_name}"
    zone_id                = "${var.maint_distribution_zone_id}"
    evaluate_target_health = false
  }
  set_identifier = "crowd-Secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
}

resource "aws_route53_health_check" "crowd" {
  ip_address        = "${aws_eip.crowd.public_ip}"
  port              = 80
  type              = "HTTP"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "crowd_hc${var.pipeline_name}"
  }
}
