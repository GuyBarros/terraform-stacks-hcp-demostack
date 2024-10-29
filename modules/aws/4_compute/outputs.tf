output "aws_instance_workers_ids" {
  value = [aws_instance.workers[*].id]
}

output "aws_instance_workers_public_dns" {
  value = [aws_instance.workers[*].public_dns]
}
