data "aws_route53_zone" "elsys" {
  name         = "elsys.itgix.eu."
  private_zone = false
}