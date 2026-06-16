# Folder State

## Module
`terraform/modules/gcp/folder`

## Stack
`terraform/terragrunt/development/folder`

## Purpose
Creates the parent GCP folder for the learning environment.

## Current Deployed State
- Folder display name: `hape-iac-development`
- Folder ID: `271160547009`
- Parent: configured GCP organization from `ORGANIZATION_ID`

## Notes
- This folder is the parent container for the development project.
- Folder deletion protection is enabled in the planned resource shape.
- Exact values are available from:

```bash
cd terraform/terragrunt/development/folder
terragrunt output
```
