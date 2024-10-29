output "vpc_security_group_id" {
  value = [aws_security_group.demostack.id]
}


 output "certificate_arn" {
value = aws_acm_certificate_validation.cert.certificate_arn
 } 

 output "validation_certificate" {
value = aws_acm_certificate_validation.cert
 }