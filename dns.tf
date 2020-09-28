locals {
  parts              = split(".", trimsuffix(var.domain_name, "."))
  parent_domain_name = join(".", slice(local.parts, 1, length(local.parts)))
}

data "aws_route53_zone" "parent" {
  name = "${local.parent_domain_name}."
}

resource "google_dns_managed_zone" "domain" {
  name     = replace(var.domain_name, ".", "-")
  dns_name = "${var.domain_name}."
}

resource "aws_route53_record" "domain_ns_records" {
  zone_id = data.aws_route53_zone.parent.zone_id
  name    = "${var.domain_name}."
  type    = "NS"
  ttl     = "60"
  records = google_dns_managed_zone.domain.name_servers
}


data "googlesiteverification_dns_token" "domain" {
  domain = var.domain_name
}

resource "google_dns_record_set" "domain" {
  managed_zone = google_dns_managed_zone.domain.name
  name         = "${data.googlesiteverification_dns_token.domain.record_name}."
  rrdatas      = [data.googlesiteverification_dns_token.domain.record_value]

  type = data.googlesiteverification_dns_token.domain.record_type
  ttl  = 60
}

resource "googlesiteverification_dns" "domain" {
  domain     = var.domain_name
  depends_on = [aws_route53_record.domain_ns_records]
}

resource google_project_service siteverification {
  service            = "siteverification.googleapis.com"
  disable_on_destroy = false
}
