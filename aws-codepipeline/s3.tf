module "codepipeline_bucket" {
 source = "../aws-s3"
 bucket = var.override_name == "" ? "${local.name}-coepipeline-artifacts" : "${var.override_name}-codepipeline-artifacts"
 tags = module.tags_s3.tags 
}