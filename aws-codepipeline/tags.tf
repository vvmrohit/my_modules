module "tags_codepipeline" {
    source = "../aws-tags"
    name = var.override_name == "" ? "${local.name}-codepipeline" : "${var.override_name}-codepipeline"
    tags = var.tags_override
}

module "tags_ci" {
    source = "../aws-tags"
    name = var.override_name == "" ? "${local.name}-ci" : "${var.override_name}-ci"
    tags = var.tags_override
}

module "tags_cd" {
    source = "../aws-tags"
    name = var.override_name == "" ? "${local.name}-cd" : "${var.override_name}-cd"
    tags = var.tags_override
}

module "tags_s3" {
    source = "../aws-tags"
    name = "${local.name}-s3"
    tags = var.tags_override
}

module "tags_iam" {
    source = "../aws-tags"
    name = "${local.name}-iam"
    tags = var.tags_override
}

module "tags_ssm" {
    source = "../aws-tags"
    name = "${local.name}-ssm"
    tags = var.tags_override
}
