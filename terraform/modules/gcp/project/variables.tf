variable "folder_id" {
  description = "Folder ID where the project is created."
  type        = string
}

variable "billing_account" {
  description = "Billing account in the format XXXXXX-XXXXXX-XXXXXX."
  type        = string
}

variable "project_name_prefix" {
  description = "Prefix used to build project ID and project name."
  type        = string
  default     = "hape-iac-dev"
}

variable "project_labels" {
  description = "Labels applied to the project."
  type        = map(string)
  default     = {}
}

variable "random_suffix_length" {
  description = "Length of random suffix appended to project ID."
  type        = number
  default     = 4
}

variable "activate_apis" {
  description = "APIs that should be enabled in the project."
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "oslogin.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}
