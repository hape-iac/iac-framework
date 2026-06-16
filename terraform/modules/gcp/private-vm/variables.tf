variable "project_id" {
  description = "Project ID where VM and IAM resources are created."
  type        = string
}

variable "zone" {
  description = "Zone where the VM is created."
  type        = string
}

variable "vm_name" {
  description = "Name of the VM instance."
  type        = string
}

variable "machine_type" {
  description = "GCE machine type for the VM."
  type        = string
  default     = "e2-micro"
}

variable "subnet_self_link" {
  description = "Self link of the subnet where the VM is attached."
  type        = string
}

variable "enable_public_ip" {
  description = "Attach an ephemeral external IP to the VM when true."
  type        = bool
  default     = false
}

variable "ssh_target_tag" {
  description = "Network tag attached to the VM for IAP SSH firewall targeting."
  type        = string
  default     = "iap-ssh"
}

variable "vm_access_user_email" {
  description = "Single user email granted IAP tunnel and OS Login access for the VM."
  type        = string
}

variable "boot_image" {
  description = "Boot image for the VM."
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB."
  type        = number
  default     = 30
}

variable "instance_labels" {
  description = "Labels applied to the VM."
  type        = map(string)
  default     = {}
}

variable "service_account_id" {
  description = "Service account ID used by the VM."
  type        = string
  default     = "vm-workload"
}

variable "service_account_display_name" {
  description = "Display name for the VM service account."
  type        = string
  default     = "VM Workload Service Account"
}

variable "service_account_roles" {
  description = "Project roles granted to the VM service account."
  type        = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

variable "grant_compute_viewer_role" {
  description = "Also grant roles/compute.viewer to the VM access user."
  type        = bool
  default     = true
}
