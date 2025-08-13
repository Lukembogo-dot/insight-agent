variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "image_tag" {
  type        = string
  description = "The Docker image tag to deploy"
}