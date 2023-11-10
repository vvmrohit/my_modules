module "tags" {
  source = "../aws-tags"
  name = var.name
  environment = var.environment
  service = ""
  tags = merge({
    "Data Classification" : "PROTECT - PRIVATE",
    "Data Residency" : "India"
  },
  var.tags_override)
}