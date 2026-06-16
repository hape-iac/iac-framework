# Project State

## Module
`terraform/modules/gcp/project`

## Stack
`terraform/terragrunt/development/project`

## Purpose
Creates the development GCP project, attaches billing, and enables required APIs.

## Current Deployed State
- Project ID: `hape-iac-dev-0me7`
- Project name: `hape-iac-dev-0me7`
- Project number: `463624054281`
- Billing account: configured through `BILLING_ACCOUNT`

## Enabled APIs
- Compute Engine API
- IAM API
- IAP API
- OS Login API
- Service Usage API

## Notes
- The project is created under the `hape-iac-development` folder.
- Project IDs include a generated suffix for global uniqueness.
- Exact values are available from:

```bash
cd terraform/terragrunt/development/project
terragrunt output
```
