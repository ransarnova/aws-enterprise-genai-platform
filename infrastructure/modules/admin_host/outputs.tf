output "instance_profile_name" {
  description = "IAM instance profile for the administration host."
  value       = aws_iam_instance_profile.this.name
}
