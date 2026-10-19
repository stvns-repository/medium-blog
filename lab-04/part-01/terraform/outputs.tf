output "secrets_manager_secret_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.app_secrets.arn
}

output "kms_key_arn" {
  description = "ARN of the KMS customer managed key"
  value       = aws_kms_key.lab04_key.arn
}

output "eso_iam_policy_arn" {
  description = "ARN of the least-privilege IAM policy"
  value       = aws_iam_policy.eso_policy.arn
}