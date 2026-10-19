# AWS KMS Key for Secrets Encryption
resource "aws_kms_key" "lab04_key" {
  description             = "KMS key for Lab 04 External Secrets Operator"
  deletion_window_in_days = 7
  enable_key_rotation     = false

  tags = {
    Environment = "lab-04"
  }
}

resource "aws_kms_alias" "lab04_alias" {
  name          = "alias/lab04-secrets-key"
  target_key_id = aws_kms_key.lab04_key.key_id
}

# AWS Secrets Manager Secret
resource "aws_secretsmanager_secret" "app_secrets" {
  name                    = "lab04/app/credentials"
  description             = "Production-grade secret payload for Lab 04"
  kms_key_id              = aws_kms_key.lab04_key.arn
  recovery_window_in_days = 0 # Immediate deletion for lab iteration
}

resource "aws_secretsmanager_secret_version" "app_secrets_val" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    API_USERNAME = "admin-user"
    API_PASSWORD = "SuperSecretLab04Password!@#"
  })
}

# Least-Privilege IAM Policy for External Secrets Operator
data "aws_iam_policy_document" "eso_policy_doc" {
  statement {
    sid       = "AllowReadSecretsAndDecrypt"
    effect    = "Allow"
    actions   = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [aws_secretsmanager_secret.app_secrets.arn]
  }

  statement {
    sid       = "AllowKMSDecrypt"
    effect    = "Allow"
    actions   = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.lab04_key.arn]
  }
}

resource "aws_iam_policy" "eso_policy" {
  name        = "Lab04ExternalSecretsPolicy"
  description = "Least-privilege policy allowing ESO to read KMS-encrypted secrets"
  policy      = data.aws_iam_policy_document.eso_policy_doc.json
}