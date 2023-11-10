resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_ia_transition" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id

  count = var.lifecycle_ia_transition_enabled ? 1 : 0
  rule {
    id = "transition-to-ia"
    status = var.lifecycle_ia_transition_enabled ? "Enabled" : "Disabled"

    transition {
      days = var.lifecycle_days_to_ia_transition
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_glacier_transition" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id

  count = var.lifecycle_glacier_transition_enabled ? 1 : 0
  rule {
    id = "transition-to-glacier"
    status = var.lifecycle_glacier_transition_enabled ? "Enabled" : "Disabled"

    transition {
      days = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }  
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_expiration" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id
  count = var.lifecycle_expiration_enabled ? 1 : 0

  rule {
    id = "expiration"
    status = var.lifecycle_expiration_enabled ? "Enabled" : "Disabled"

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }
  depends_on = [ aws_s3_bucket_lifecycle_configuration.lifecycle_ia_transition, aws_s3_bucket_lifecycle_configuration.lifecycle_glacier_transition, aws_s3_bucket.s3_bucket_dev, aws_s3_bucket.s3_bucket_prod ]
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_versions_ia_transition" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id

  count = var.lifecycle_versions_ia_transition_enabled ? 1 : 0
  rule {
    id = "noncurrent-versions-transition-to-ia"
    status = var.lifecycle_versions_ia_transition_enabled ? "Enabled" : "Disabled"

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_versions_days_to_ia_transition
      storage_class = "STANDARD_IA"
    } 
  }
  depends_on = [aws_s3_bucket.s3_bucket_dev, aws_s3_bucket.s3_bucket_prod,aws_s3_bucket_lifecycle_configuration.lifecycle_expiration, aws_s3_bucket_lifecycle_configuration.var.lifecycle_versions_expiration]
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_versions_days_to_glacier_transition" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id

  count = var.lifecycle_versions_glacier_transition_enabled ? 1 : 0
  rule {
    id = "noncurrent-versions-transition-to-glacier"
    status = var.lifecycle_versions_glacier_transition_enabled ? "Enabled" : "Disabled"

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_versions_days_to_glacier_transition
      storage_class = "GLACIER"
    } 
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_versions_expiration" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id
  count = var.lifecycle_versions_expiration_enabled ? 1 : 0
  rule {
    id = "noncurrent-versions-expiration"
    status = var.lifecycle_versions_expiration_enabled ? "Enabled" : "Disabled"

    noncurrent_version_expiration {
      noncurrent_days = var.lifecycle_versions_days_to_expiration
    } 
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "custom_rules" {
  bucket = var.prevent_destroy == true ? aws_s3_bucket.s3_bucket_prod[0].id : aws_s3_bucket.s3_bucket_dev[0].id
  count = length(var.custom_lifecycle_rules) == 0 ? 0 : 1
  dynamic "rule" {
    for_each = var.custom_lifecycle_rules
    content {
        id = rule.value.id != null ? rule.value.id : "custom-lifecycle-rule-${rule.key +1}"
        status = rule .value.enabled ? "Enabled" : "Disabled"

        filter {
            prefix = lookup (rule.value , "prefix", null)
        }

        dynamic "expiration" {
            for_each = rule.value.expression != null ? [rule.value.expiration] : []
            content {
                days = lookup(expiration.value, "days", null)
            }
        }

        dynamic "nocurrent_version_expiration"{
        for_each = rule.value.nocurrent_version_expiration != null ? [rule.value.nocurrent_version_expiration] : []
        content {
            noncurrent_days = lookup (noncurrent_version_expiration.value, "danoncurrent_daysys", null)
        }
        }
        dynamic "transition" {
            for_each = rule.value.transition != null ? [rule.value.transition] : []
            content {
                days = lookup(transition.value, "days", null)
                storage_class = lookup(transition.value, "storage_class", null)
            }
        }
        dynamic "noncurrent_version_transition" {
            for_each = rule.value.noncurrent_version_transition !=null ? [rule.value.noncurrent_version_transition] : []
            content {
                noncurrent_days = lookup ( noncurrent_version_transition.value, "noncurrent_days", 30)
                storage_class = lookup ( noncurrent_version_transition.value, "storage_class", null)
            }
        }
    }
  }
}


