output "project_id" {
  description = "Created GCP project ID."
  value       = google_project.this.project_id
}

output "project_number" {
  description = "Created GCP project number."
  value       = google_project.this.number
}

output "project_name" {
  description = "Created GCP project name."
  value       = google_project.this.name
}
