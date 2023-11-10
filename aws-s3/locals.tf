locals {
  name = var.overide_bucket_name ? lower(var.name) : lower("${var.name}-${var.environment}-${module.common.aws_account_id}")
  create_kms_key = var.create_kms_key && !var.use_aes_sse_algorithm ? 1 : 0
  bucket_policy = var.use_bucket_policy ? var.bucket_policy : null
  kms_key = coalescelist(
    aws_kms_key.key[*],
    data.aws_kms_key.key[*],
    ["-"]
  )[0]
}