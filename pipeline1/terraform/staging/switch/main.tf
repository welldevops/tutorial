provider "aws" {
  region = "${var.aws_region}"
}
data "aws_route53_zone" "main" {
  name         = "${var.zone_name}"
}
resource "aws_route53_record" "env" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.environment}.${data.aws_route53_zone.main.name}"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "dev"
  records        = ["${var.environment}${var.site == "1" ? "1" : "2"}.${data.aws_route53_zone.main.name}"]
}
