# Inputs

## Required Inputs
- `organization_id`: target GCP organization ID.
- `billing_account`: billing account ID to attach to project.
- `vm_access_user_email`: single user email for IAP and OS Login access.

## Defaulted Inputs
- `region`: `europe-west1`
- `zone`: `europe-west1-b`
- `machine_type`: sourced from `MACHINE_TYPE`, default `e2-micro`
- `enable_cloud_nat`: `false`
- `enable_public_ip`: `false`
- `use_public_subnet`: `false`
- `folder_display_name`: `hape-iac-development`
- `project_name_prefix`: `hape-iac-dev`
- `private_subnet_name`: `workload-private-euw1`
- `private_subnet_cidr`: `10.42.0.0/24`
- `public_subnet_name`: `ingress-public-euw1`
- `public_subnet_cidr`: `10.42.1.0/24`

## Notes
- Project IDs must be globally unique; suffix generation is handled by module logic.
- Sensitive values should be supplied via environment variables or ignored local vars, not committed files.
- Use `enable_public_ip=true` to attach an ephemeral external IP to the VM.
- Use `use_public_subnet=true` to place the VM in the public subnet profile.

## Identity Model
- `GOOGLE_APPLICATION_CREDENTIALS` is the identity Terraform uses to create and manage resources.
- `vm_access_user_email` is the human user identity that receives IAP tunnel and OS Login roles to access the private VM.
