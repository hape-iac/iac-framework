resource "random_string" "project_suffix" {
  length  = var.random_suffix_length
  special = false
  upper   = false
}

locals {
  project_id = "${var.project_name_prefix}-${random_string.project_suffix.result}"
}

resource "google_project" "this" {
  project_id      = local.project_id
  name            = local.project_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
  labels          = var.project_labels

  auto_create_network = false
}

resource "google_project_service" "required" {
  for_each = toset(var.activate_apis)

  project            = google_project.this.project_id
  service            = each.value
  disable_on_destroy = false
}
