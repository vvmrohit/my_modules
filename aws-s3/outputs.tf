output "bucket" {
  value = coalescelist(
    aws_s3_bucket.s3_bucket_prod[*],
    aws_s3_bucket.s3_bucket_dev[*]
  )[0]
}

output "bucket_name" {
  value = coalescelist(
    aws_s3_bucket.s3_bucket_prod[*].bucket,
    aws_s3_bucket.s3_bucket_dev[*].bucket
  )[0]
}

output "bucket_arn" {
  value = coalescelist(
    aws_s3_bucket.s3_bucket_prod[*].arn,
    aws_s3_bucket.s3_bucket_dev[*].arn
  )[0]
}

output "kms_key" {
  value = local.kms_key
}

