# VM State

## Module
`terraform/modules/gcp/private-vm`

## Stack
`terraform/terragrunt/development/private-vm`

## Purpose
Creates the development VM and grants terminal access through IAP and OS Login.

## Current Deployed State
- VM name: `hape-iac-dev-vm`
- Project ID: `hape-iac-dev-0me7`
- Zone: `europe-west1-b`
- Machine type: `e2-micro`
- VM service account: `vm-workload@hape-iac-dev-0me7.iam.gserviceaccount.com`
- External IP: assigned in current Terragrunt output.

## Network Mode
- Private VM mode uses `workload-private-euw1`.
- Public VM mode uses `ingress-public-euw1` and attaches an external IP.
- Current runtime mode is controlled by `ENABLE_PUBLIC_IP` and `USE_PUBLIC_SUBNET` in `.env.local`.

## Access Model
- OS Login is enabled on the VM.
- IAP tunnel access is granted to `VM_ACCESS_USER_EMAIL`.
- Compute viewer access is granted to the VM access user when enabled.

## Terminal Access
Use:

```bash
make ssh
```

This resolves the project and VM name from Terragrunt outputs and opens an IAP SSH session.

## Notes
- Use `make destroy-vm` before recreating the VM with a different subnet mode.
- Exact values are available from:

```bash
cd terraform/terragrunt/development/private-vm
terragrunt output
```
