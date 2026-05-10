variable "gitlab_url" {
 type = string
 # Use the correct URL here.
 default = "http://gitlab.devlabs.com//api/v4/"
}
variable "gitlab_token" {
 type = string
 sensitive = true # Hide from the logs.
}
