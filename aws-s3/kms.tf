resource "aws_kms_key" "key" {
  count = local.create_kms_key
  description = "KMS Key for ${local.name} S3 bucket"
  deletion_window_in_days = 7
  enable_key_rotation = true
  policy = var.kms_key_policy
  tags = module.tags.tags
}