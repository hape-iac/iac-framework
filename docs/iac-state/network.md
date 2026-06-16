# Network State

## Module
`terraform/modules/gcp/network`

## Stack
`terraform/terragrunt/development/network`

## Purpose
Creates the custom VPC, subnet profiles, IAP SSH firewall, and optional NAT.

## Current Deployed State
- VPC name: `hape-iac-dev-vpc`
- Private subnet: `workload-private-euw1`
- Public subnet: `ingress-public-euw1`
- Region: `europe-west1`
- IAP SSH target tag: `iap-ssh`

## Subnet Profiles
- Private subnet is intended for private workloads without direct external IP.
- Public subnet is intended for workloads that opt into public IP mode.

## SSH Firewall
- SSH ingress is limited to the IAP source range.
- VM instances use the `iap-ssh` network tag for IAP-based SSH access.

## NAT
- Cloud NAT is optional.
- Current default is disabled unless `enable_cloud_nat` is set to `true`.

## Notes
- The public subnet exists to support public VM mode.
- Exact values are available from:

```bash
cd terraform/terragrunt/development/network
terragrunt output
```
