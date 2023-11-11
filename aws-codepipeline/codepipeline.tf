resource "aws_codepipeline" "main" {
  # checkov:skip=CKV_AWS_219: KMS cost money
  name = var.override_name == "" ? "${local.name}-pipeline" : "${var.override_name}-pipeline"
  role_arn = module.codepipeline_iam_role.arn

  artifact_store {
    location = module.codepipeline_bucket.bucket.id
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "ThirdParty"
      provider = "GitHub"
      version = "1"
      output_artifacts = [var.var.override_name == "" ? "${local.name}-artifact" : "${var.override_name}-artifact"]

      configuration = {
        Owner = var.repository_owner
        Repo = var.repository_name
        Branch = var.repository_branch
        OAuthToken = data.aws_ssm_parameter.github_token.value
        PollForSourceChanges = var.enable_webhooks ? false : true
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = [var.var.override_name == "" ? "${local.name}-artifact" : "${var.override_name}-artifact"]
      version = "1"

      configuration = {
        ProjectName = aws_codebuild_project.ci.name
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name = "Approval"
      category = "Approval"
      owner = "AWS"
      provider = "Manual"
      version = "1"

      configuration = {
        NotificationArn = var.approval_sns_topic_arn == "" ? null : var.approval_sns_topic_arn
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = [var.var.override_name == "" ? "${local.name}-artifact" : "${var.override_name}-artifact"]
      version = "1"
      configuration = {
        ProjectName = aws_codebuild_project.cd.name
      }
    }
  }
  tags = module.tags_codepipeline.tags
}

resource "aws_codepipeline_webhook" "webhook" {
  count = var.enable_webhooks ? 1 : 0
  name = var.override_name == "" ? "${local.name}-codepipeline_webhook" : "${var.override_name}-codepipeline_webhook"
  authentication = "GITHUB_HMAC"
  target_action = "Source"
  target_pipeline = aws_codepipeline.main.name

  authentication_configuration {
    secret_token = var.webhook_secret
  }

  filter {
    json_path = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }

  tags = module.tags_codepipeline.tags
}

resource "github_repository_webhook" "webhook" {
  count = var.enable_webhooks ? 1 : 0
  repository = data.github_repository.repo.name

  configuration {
    url = aws_codepipeline_webhook.webhook[0].url
    content_type = "json"
    insecure_ssl = false
    secret = var.webhook_secret
  }
  events = ["push"]
}