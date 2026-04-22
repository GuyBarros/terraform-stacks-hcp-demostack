output "subnet_ids" {
  value = aws_subnet.demostack.*.id
}