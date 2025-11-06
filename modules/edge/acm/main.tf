resource "aws_acm_certificate" "this" {
  private_key = var.private_key
  certificate_body = var.certificate_body

  tags = merge(var.common_tags, {
    Name = "${var.name}-certificate"
  })
}