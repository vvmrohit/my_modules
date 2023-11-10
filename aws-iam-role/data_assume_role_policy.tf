data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      identifiers = var.service_pricipals
      type        = "Service"
    }

    principals {
      identifiers = var.aws_principals
      type        = "AWS"
    }
    actions = [
      "sts:AssumeRole"
    ]

    dynamic "condition" {
      for_each = var.trust_conditions
      content {
        test     = condition.value["test"]
        variable = condition.value["variable"]
        values   = condition.value["values"]
      }
    }
  }
}