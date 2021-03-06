variable "team_name" {
  default = "pecs"
}

variable "environment-name" {
  default = "staging"
}

variable "is-production" {
  default = "false"
}

variable "infrastructure-support" {
  default = "PECS: pecs-team@digital.justice.gov.uk"
}

variable "application" {
  default = "HMPPS Book a secure move frontend"
}

variable "namespace" {
  default = "hmpps-book-secure-move-frontend-staging"
}

variable "repo_name" {
  default = "hmpps-book-secure-move-frontend"
}

// The following two variables are provided at runtime by the pipeline.
variable "cluster_name" {}

variable "cluster_state_bucket" {}
