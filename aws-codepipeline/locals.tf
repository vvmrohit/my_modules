locals {
  name = "${var.project}-${var.service}-${var.environment}"
  prevent_destroy = var.environment == "dev" ? false : true
  
  cache_options = {
    "LOCAL" = {
        type = "LOCAL"
        modes = "LOCAL_CUSTOM_CACHE"
    },
    "NO_CACHE" = {
        type = "NO_CACHE"
    }
  }
  cache = local.cache_options[var.cache_type]
}