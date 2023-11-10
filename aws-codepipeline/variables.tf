variable "project" {
  description = "The name of the project"
  type = string
}

variable "service" {
  description = "The name of the service"
  type = string
}

variable "environment" {
  description = "The name of the environment"
  type = string
}
variable "region" {
  default = "ap-south-1"
  type = string
  description = "Region parameter used in IAM policies"
}

variable "repository_owner" {
  default = "Rohit_Pandey"
  type = string
  description = "Owner of GitHub repo, org or individual"
}

variable "repository_name" {
  type = string
  description = "The name of the repository to build"
}

variable "repository_branch" {
  default = "main"
  type = string
  description = "The name of the branch to build"
}

variable "github_token_ssm_path" {
    type = string
    description = "The SSM Paramter Sote path where the Github OAuth token is stored"
}

variable "buildspec_ci" {
  default = "pipelines/buildspec-feature.yml"
  type = string
  description = "The CodeBuild buildspec path for the CI job"
}

variable "buildspec_cd" {
  default = "pipelines/buildspec-master.yml"
  type = string
  description = "The CodeBuild buildspec path for the CD job"
}
variable "codebuild_ci_iam_role" {
  description = "The CodeBuild CI IAM role arn"
  type = string
}

variable "codebuild_cd_iam_role" {
    description = "The CodeBuild CD IAM role arn"
}

variable "cd_build_timeout" {
  description = "How long in minutes for the CD AWS codebuild to wait until timeout"
  type = string
  default = "60"
}
variable "ci_build_timeout" {
  description = "How long in minutes for the CI AWS codebuild to wait until timeout"
  type = string
  default = "30"
}

variable "build_image" {
  default = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
  description = "The Codebuild build image for CI and CD job"
  type = string
}

variable "image_pull_credentials_type" {
  default = "CODEBUILD"
  type = string
  description = "The image pull credential type, either CODEBUILD or SERVICE_ROLE"
}

variable "approval_sns_topic_arn" {
  default = ""
  type = string
  description = "The arn of the SNS topic used for approval requests"
}

variable "ssm_base_path" {
  type = string
  description = "The base project SSM path to use for storing the CODEPipeline deployed version"
}

variable "vpc_connect" {
  type = list(any)
  default = [  ]
}

variable "enable_webhooks" {
  type = bool
  default = true
}

variable "webhook_secret" {
  type = string
  default = ""
}
variable "compute_type" {
  type = string
  default = "BUILD_GENERAL1_SMALL"
}

variable "landscape" {
  type = string
}

variable "override_name" {
    type = string
    description = "THis variable is used if you do not want to follow the default nameing convetion "
}

variable "cache_type" {
  type = string
  default = "LOCAL"
}

variable "tags_override" {
  type = map(string)
  description = "A custom map of tags to override default tags"
}


