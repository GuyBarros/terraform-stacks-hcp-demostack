output "vpc" {
  value = aws_vpc.demostack
}

output "aws_iam_instance_profile_name"{
  value = aws_iam_instance_profile.consul-join.name
}

output "aws_key_pair_id"{
value = aws_key_pair.demostack.id
}
