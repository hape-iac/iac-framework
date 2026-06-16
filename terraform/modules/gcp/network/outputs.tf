output "network_name" {
  description = "Name of the VPC network."
  value       = google_compute_network.this.name
}

output "network_self_link" {
  description = "Self link of the VPC network."
  value       = google_compute_network.this.self_link
}

output "subnet_name" {
  description = "Name of the private subnet."
  value       = google_compute_subnetwork.private.name
}

output "subnet_self_link" {
  description = "Self link of the private subnet."
  value       = google_compute_subnetwork.private.self_link
}

output "private_subnet_name" {
  description = "Name of the private subnet."
  value       = google_compute_subnetwork.private.name
}

output "private_subnet_self_link" {
  description = "Self link of the private subnet."
  value       = google_compute_subnetwork.private.self_link
}

output "public_subnet_name" {
  description = "Name of the public ingress subnet."
  value       = google_compute_subnetwork.public.name
}

output "public_subnet_self_link" {
  description = "Self link of the public ingress subnet."
  value       = google_compute_subnetwork.public.self_link
}

output "ssh_target_tag" {
  description = "Network tag used for IAP-based SSH firewall targeting."
  value       = var.ssh_target_tag
}
