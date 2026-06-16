output "folder_id" {
  description = "Resource ID of the created folder."
  value       = google_folder.this.folder_id
}

output "folder_name" {
  description = "Display name of the created folder."
  value       = google_folder.this.display_name
}
