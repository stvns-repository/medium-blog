variable "gitlab_url" {
 type = string
 # Use the correct URL here.
 default = "http://gitlab.devlabs.com//api/v4/"
}
variable "gitlab_token" {
 type = string
 sensitive = true # Hide from the logs.
}

#Added in part 4
variable "db_password" {
  type        = string
  description = "Password for Postgres, injected via TF_VAR_db_password"
  sensitive   = true
}

variable "api_key" {
  type        = string
  description = "External API Key, injected via TF_VAR_api_key"
  sensitive   = true
}

variable "app_image" {
  type        = string
  description = "The ECR image URI provided by the GitLab pipeline"
  default     = "placeholder"
}
