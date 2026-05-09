variable "gitlab_url" {
 type = string
 # Use the correct URL here.
 default = "http://gitlab.cicdpractice.com/api/v4/"
}
variable "gitlab_token" {
 type = string
 sensitive = true # Hide from the logs.
}
