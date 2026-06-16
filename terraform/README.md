# Terraform Layout

## Purpose
Holds module source and Terragrunt stack wiring for IaC Milestone 1.

## Structure
- `modules/gcp/`: reusable GCP module boundaries.
- `terragrunt/`: execution entrypoint and environment stack definitions.

## Gate
Stack-level `terragrunt.hcl` files are generated only after explicit user approval.
