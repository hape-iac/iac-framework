variable "project_id" {
  description = "Project ID where networking resources are created."
  type        = string
}

variable "region" {
  description = "Region for subnet and Cloud NAT resources."
  type        = string
}

variable "network_name" {
  description = "Name of the custom VPC network."
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private workload subnet."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR range of the private workload subnet."
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the public ingress subnet."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR range of the public ingress subnet."
  type        = string
}

variable "enable_cloud_nat" {
  description = "Enable outbound internet for private workloads using Cloud NAT."
  type        = bool
  default     = false
}

variable "router_name" {
  description = "Cloud Router name when Cloud NAT is enabled."
  type        = string
  default     = "hape-iac-dev-router"
}

variable "nat_name" {
  description = "Cloud NAT name when Cloud NAT is enabled."
  type        = string
  default     = "hape-iac-dev-nat"
}

variable "ssh_target_tag" {
  description = "Network tag used by VMs that allow SSH from IAP."
  type        = string
  default     = "iap-ssh"
}
