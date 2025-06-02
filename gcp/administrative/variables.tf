variable "zone" {
  description = "The GCP zone where resources will be created. A list of zones can be found at https://cloud.google.com/compute/docs/regions-zones"
  type        = string
  default     = "us-east1" # normally I would use europe-west3-a, but the us regions have some free tier space quotas (https://cloud.google.com/free/docs/free-cloud-features#free-tier-usage-limits)
}

variable "participants" {
  description = "A list of users with their email, that will get the minimum role to create resources"
  type = list(object({
    email = string
    id    = string # must be The account id that is used to generate the service account email address and a stable unique id. https://registry.terraform.io/providers/hashicorp/google/6.37.0/docs/resources/google_service_account#argument-reference
  }))
}

variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
  default     = "terraform-learning-460507"
}