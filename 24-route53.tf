#resource "aws_route53_zone" "example-app_com" {        #use this to create new route53 and comment below data section
data "aws_route53_zone" "example-app_com" {             #use this to use existing route53 and comment above resource section
  name = "example-app.com"
  #tags = {
  #  Environment = "Development"
  #}
}

resource "aws_acm_certificate" "example-app-wild-card-dev" {
  domain_name       = "example-app.com"
  subject_alternative_names = ["*.example-app.com"]
  validation_method = "DNS"
#  renewal_eligibility =
  tags = {
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "example-app-wild-card-dev" {
  certificate_arn         = aws_acm_certificate.example-app-wild-card-dev.arn
  validation_record_fqdns = [for record in aws_route53_record.example-app : record.fqdn]
}

resource "aws_route53_record" "example-app" {
  for_each = {
    for dvo in aws_acm_certificate.example-app-wild-card-dev.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.example-app_com.zone_id
}

output "acm_certificate" {
  sensitive = true
  value = aws_acm_certificate.example-app-wild-card-dev
}

output "acm_certificate_validation" {
  value = aws_acm_certificate_validation.example-app-wild-card-dev
}

output "route53_record" {
  value = aws_route53_record.example-app
}