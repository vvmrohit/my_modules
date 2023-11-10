resource "aws_s3_bucket" "s3_bucket_dev" {
  #chekov:skip=CKV_AWS_144
  count = var.prevent_destroy == true ? 0 : 1
  bucket = local.name
  tags = module.tags.tags
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket" "s3_bucket_prod" {
  #chekov:skip=CKV_AWS_144
  count = var.prevent_destroy == true ? 0 : 1
  bucket = local.name
  tags = module.tags.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id

  rule {
    object_ownership = "BuckeOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id
  acl = var.acl
  depends_on = [ 
    aws_s3_bucket_ownership_controls.bucket_ownership
   ]
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
    mfa_delete =  var.mfa ? "Disabled" : "Enabled"
  }
  mfa = var.mfa
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].bucket : aws_s3_bucket.s3_bucket_dev[0].bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.use_aes_sse_algorithm ? null : local.kms_key.role_arn
      sse_algorithm = var.use_aes_sse_algorithm ? "AES256" : "aws:kms"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  for_each = { for index, rule in vars.cors_rules : index => rule}
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id

  cors_rule {
    allowed_headers = each.value.allowed_headers
    allowed_methods = each.value.allowed_methods
    allowed_origins = each.value.allowed_origins
    expose_headers = each.value.expose_headers
    max_age_seconds = each.value.max_age_seconds
  }
}

resource "aws_s3_bucket_logging" "logging" {
  count = var.logging_target_bucket_name !=null ? 1 : 0
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id

  target_bucket = var.logging_target_bucket_name
  target_prefix = var.logging_target_prefix
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  count = local.bucket_policy == null ? 0 : 1
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id
  policy = var.bucket_policy
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id

  block_public_acls = true

  ignore_public_acls = true

  block_public_policy = true

  restrict_public_buckets = true
}