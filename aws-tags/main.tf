locals {
  default_tags = {
    "Name" : var.name
    "Environment" : var.environment
    "Service" : lower(var.service)
    "Project" : var.project
    "owner" : var.owner
    "Creator" : var.creator
  }
  merged_tags = merge(local.default_tags, var.tags)
}