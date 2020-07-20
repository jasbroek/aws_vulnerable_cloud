# Output variable definitions
output "fc_aws_account_id" {
  value = "${data.aws_caller_identity.aws-account-id.account_id}"
}

output "fc_ec2_public_ip" {
  value = "${aws_instance.fc-ubuntu-18.public_ip}"
}
output "fc_ec2_public_dns" {
  value = "http://${aws_instance.fc-ubuntu-18.public_dns}"
}
output "fc_ec2_ssh_connect" {
  value = "ssh -i \"../assets/keys/ssh_key\" ubuntu@${aws_instance.fc-ubuntu-18.public_dns}"
}

output "alice_access_key_id" {
  value = aws_iam_access_key.alice.id
}
output "alice_secret_key" {
  value = aws_iam_access_key.alice.secret
}

output "bob_access_key_id" {
  value = aws_iam_access_key.bob.id
}
output "bob_secret_key" {
  value = aws_iam_access_key.bob.secret
}

output "fc_snapshot_id" {
  value = aws_ebs_snapshot.ubuntu18_public_snapshot.id
}

output "s3_readable_bucket" {
  value = "http://${aws_s3_bucket.fc_web_bucket.website_endpoint}"
}
output "s3_writable_bucket" {
  value = "http://${aws_s3_bucket.writable_bucket.website_endpoint}"
}