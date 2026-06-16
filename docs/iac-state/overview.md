# Deployment Overview

## Current State
The Milestone 1 development environment is deployed in GCP through Terragrunt stacks.

## Deployed Stack Summary
- Folder stack is applied.
- Project stack is applied.
- Network stack is applied.
- VM stack is applied.
- VM outputs currently show an assigned external IP, which means public VM mode is active in the applied VM state.

## Environment Shape
```text
GCP Organization
└── Folder: hape-iac-development
    └── Project: hape-iac-dev-0me7
        ├── Custom VPC: hape-iac-dev-vpc
        ├── Private subnet: workload-private-euw1
        ├── Public subnet: ingress-public-euw1
        └── VM: hape-iac-dev-vm
```

## Access Model
- SSH access is managed through IAP and OS Login.
- The VM access user is configured through `VM_ACCESS_USER_EMAIL`.
- The VM has a workload service account for logging and monitoring.

## Public Mode
The current configuration supports public VM mode through:
- `ENABLE_PUBLIC_IP=true`
- `USE_PUBLIC_SUBNET=true`

Use `terragrunt output` in each stack directory for exact current values.
