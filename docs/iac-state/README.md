# IaC State

## Purpose
This directory records a lightweight, human-readable snapshot of what the Milestone 1 IaC framework has deployed.

## Contents
- `overview.md`: general deployment overview.
- `folder.md`: GCP folder state.
- `project.md`: GCP project state.
- `network.md`: VPC, subnet, and SSH firewall state.
- `vm.md`: VM and access state.

## Notes
- This is not a replacement for Terraform state.
- Use Terragrunt outputs for exact live values when needed.
- Keep this documentation high level and avoid recording secrets or personal credentials.
