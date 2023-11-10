module "tags" {
  source = "../aws-tags"
  name   = local.role_name
  tags   = var.tags_override
}