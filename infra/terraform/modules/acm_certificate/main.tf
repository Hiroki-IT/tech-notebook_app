#=============
# Input Value
#=============
// App Info
variable "app_name" {}
variable "app_domain_name" {}
variable "app_sub_domain_name" {}

// Route53
variable "route53_zone_id" {}

#============
# 証明書発行
#============
resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = var.app_domain_name // ネイキッドドメイン
  subject_alternative_names = ["*.${var.app_domain_name}"] // サブドメイン群
  validation_method         = "DNS"

  tags = {
    Name = var.app_domain_name
  }

  // 証明書の再生成のタイミング
  lifecycle {
    create_before_destroy = true
  }
}

// 証明書の検証
resource "aws_route53_record" "route53_record_certificate" {
  zone_id = var.route53_zone_id
  name    = aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_type
  records = [aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

// 証明書検証の待機
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [aws_route53_record.route53_record_certificate.fqdn]
}
