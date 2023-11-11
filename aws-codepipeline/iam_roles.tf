module "codebuild_cd_iam_role" {
  source = "../aws-iam-role"
  project = var.project
  service = "${var.service}-codepipeline"
  environment = var.environment
  assume_role_policy = data.aws_iam_policy_document.codepipeline_trust_policy_document.json
  policy_document = data.aws_iam_policy_document.codepipeline_policy_document.json
  service_pricipals = ["codepipeline.amazonaws.com"]
  permissions_boundry = data.aws_iam_policy.permissions_boundary.name
  tags_override = module.tags_iam.tags
}

data "aws_iam_policy_document" "codepipeline_trust_policy_document" {
  statement {
    effect = "Allow"
    principals {
        type = "Service"
        identifiers = [
        "codepipeline.amazonaws.com"
        ]
    }
    actions = ["sts:AssumeRole"]
  }

}

data "aws_iam_policy_document" "codepipeline_policy_document" {
    statement {
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey*"
      ]
      resources = [
        module.codepipeline_bucket.kms_key.arn
      ]
    }
    statement {
      effect = "Allow"

      actions = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketBersioning",
        "s3:PutObject"
      ]

      resources = [
        module.codepipeline_bucket.bucket.arn,
        "${module.codepipeline_bucket.bucket.arn}/*"
      ]
    }
    statement {
      effect = "Allow"

      actions = [
        "codebuild:BatchgetBuilds",
        "codebuild:StartBuild"
      ]
      resources = [
        "arn:aws:codebuild:${var.region}:${data.aws_caller_identity.current.account_id}:project/${aws_codebuild_project.ci.name}",
        "arn:aws:codebuild:${var.region}:${data.aws_caller_identity.current.account_id}:project/${aws_codebuild_project.cd.name}"

      ]
    }

    dynamic "statement" {
      for_each = var.approval_sns_topic_arn == "" ? [] : [1]
      content {
        effect = "Allow"
        actions = [
            "sns:Publish"
        ]

        resources = [
            var.var.approval_sns_topic_arn
        ]
      }
    }
}

data "aws_iam_policy" "permission_boundary" {
    arn = var.permissions_boundry
}
