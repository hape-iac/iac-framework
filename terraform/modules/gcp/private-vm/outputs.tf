output "vm_name" {
  description = "Name of the created VM."
  value       = google_compute_instance.this.name
}

output "vm_self_link" {
  description = "Self link of the created VM."
  value       = google_compute_instance.this.self_link
}

output "vm_internal_ip" {
  description = "Internal IP of the created VM."
  value       = google_compute_instance.this.network_interface[0].network_ip
}

output "vm_external_ip" {
  description = "External IP of the created VM when public IP is enabled."
  value       = try(google_compute_instance.this.network_interface[0].access_config[0].nat_ip, null)
}

output "vm_service_account_email" {
  description = "Email of the VM service account."
  value       = google_service_account.vm.email
}
