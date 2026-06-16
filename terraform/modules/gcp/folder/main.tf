resource "google_folder" "this" {
  display_name = var.folder_display_name
  parent       = "organizations/${var.organization_id}"
}
