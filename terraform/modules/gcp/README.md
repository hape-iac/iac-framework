# GCP Modules

## Purpose
Reusable Terraform modules for Milestone 1 golden-path infrastructure.

## Modules
- `folder`: creates one GCP folder under the provided organization.
- `project`: creates one GCP project and binds billing.
- `network`: creates custom VPC, subnet, and optional Cloud NAT.
- `private-vm`: creates private VM and SSH access controls via IAP and OS Login.
