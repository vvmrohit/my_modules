resource "aws_codebuild_project" "ci" {
  name = var.override_name == "" ? "${local.name}-ci" : "${var.override_name}-ci"
  service_role = var.codebuild_ci_iam_role
  build_timeout= var.ci_build_timeout
  
  cache {
    type = lookup(local.cache, "type", null)
    modes = lookup(local.cache, "modes", null)
  }

  environment {
    compute_type = var.compute_type
    image = var.build_image
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = var.image_pull_credentials_type
    privileged_mode = true
    environment_variable {
      name = "ENVIRONMENT"
      value = var.environment
    }
  }
  source {
    type = "CODEPIPELINE"
    buildspec = var.buildspec_ci
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  dynamic "vpc_config" {
    for_each = var.vpc_connect
    content {
      vpc_id = vpc_config.value.vpc_id
      subnets = vpc_config.value.subnets_id
      security_group_ids = vpc_config.value.security_group_ids
    }
  }
  tags = module.tags_ci.tags
}