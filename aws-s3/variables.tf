variable "name" {
  type = string
}

variable "environment" {
  default = "dev"
  type = string
}

variable "kms_key" {
  default = {}
  type = any
}

variable "create_kms_key" {
  default = false
  type = bool
}

variable "prevent_destroy" {
  default = false
  type = bool
}

variable "force_destroy" {
  default = false
  type = bool
}

variable "mfa" {
  default = ""
  type = string
}

variable "lifecycle_ia_transition_enabled" {
  default = false
  type = bool
}

variable "lifecycle_days_to_ia_transition" {
  default = 180
  type = number
}

variable "lifecycle_glacier_transition_enabled" {
  default = false
  type = bool
}

variable "lifecycle_days_to_glacier_transition" {
  default = 365
  type = number
}

variable "lifecycle_expiration_enabled" {
  default = false
  type = bool
}

variable "lifecycle_days_to_expiration" {
  default = null
  type = number
}

variable "lifecycle_versions_ia_transition_enabled" {
  default = false
  type = bool
}

variable "lifecycle_versions_days_to_ia_transition" {
  default = 180
  type = number
}

variable "lifecycle_versions_glacier_transition_enabled" {
  type = bool
  default = false
}

variable "lifecycle_versions_days_to_glacier_transition" {
  default = 360
  type = number
}

variable "lifecycle_versions_expiration_enabled" {
  default = false
  type = bool
}

variable "lifecycle_versions_days_to_expiration" {
  default = null
  type = number
}

variable "custom_lifecycle_rules" {
  description = "Specify additional lifecycle rules for the bucket e.g Prefix specific"

  type = list (object({
    id = string
    enabled = bool
    Prefix = string
    expiration = object({
      days = number 
    })
    transition = object({
      days = number
      storage_class = string 
    })
    noncurrent_version_expiration = object({
      days = number 
    })
    noncurrent_version_transition = object({
      days = number
      storage_class = string 
    })
  }))
  default = []
}

variable "kms_key_policy" {
  default = null
  type = string
}
variable "bucket_policy" {
  default = null
  type = string
}

variable "use_bucket_policy" {
  default = false
  type = bool
}

variable "overide_bucket_name" {
  default = false
  type = bool
}
variable "cors_rules" {
  type = list (
    object ({
        allowed_headers = list(string)
        allowed_methods = list(string)
        allowed_origins = list(string)
        expose_headers = list(string)
        max_age_seconds = number
    })
  )
}

variable "tags_override" {
  type = map(string)
  default = {}
}

variable "acl" {
  default = "private"
  type = string
}

variable "logging_target_bucket_name" {
  default = null
  type = string
}

variable "logging_target_prefix" {
  default = null
  type = string
}

variable "versioning" {
  default = true
  type = bool
}


variable "use_aes_sse_algorithm" {

## kepping deafult = true as kms cost money
  default = true
  type = bool
}