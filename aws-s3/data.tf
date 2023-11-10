data "aws_kms_key" "key" {
  count = local.create_kms_key == 0 && !var.use_aes_sse_algorithm ? 1 : 0
  key_id = var.kms_key.id
}