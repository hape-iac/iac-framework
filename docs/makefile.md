# Makefile Commands

## Purpose
Provide one local command interface for preview, apply, and destroy operations across the Milestone 1 Terragrunt stacks.

## Prerequisites
- `python3` is installed locally.
- `gcloud` is installed locally and authenticated.
- `terragrunt` is installed locally.
- For `preview`, `apply`, and `destroy`: `.env.local` exists in `iac-framework/` or `GOOGLE_APPLICATION_CREDENTIALS` is exported in your shell.
- You run commands from `iac-agent/iac-framework/`.

## Show Help
```bash
make help
```

## Init
```bash
make init
```

Behavior:
- Runs `scripts/init_workspace.py`.
- Extracts first available billing account ID from:
  - `gcloud billing accounts list --format=value(name)`
- Extracts first available organization ID from:
  - `gcloud organizations list --format=value(name)`
- Creates or overwrites `.env.local` with:
  - `BILLING_ACCOUNT`
  - `ORGANIZATION_ID`
  - `GOOGLE_APPLICATION_CREDENTIALS`
  - `VM_ACCESS_USER_EMAIL`
  - `MACHINE_TYPE`
  - `ENABLE_PUBLIC_IP`
  - `USE_PUBLIC_SUBNET`
- Sets `.env.local` permission to `600`.
- Optional init arguments can be passed with `INIT_ARGS`, for example:
  - `make init INIT_ARGS='--enable-public-ip true --use-public-subnet true'`
  - `make init INIT_ARGS='--machine-type e2-standard-2'`

## Preview
```bash
make preview
```

Behavior:
- Runs `terragrunt hcl format` once from `terraform/terragrunt/development`.
- Runs `terragrunt init`, `terragrunt validate`, and `terragrunt plan` in stack order:
  1. `folder`
  2. `project`
  3. `network`
  4. `private-vm`

## Apply
```bash
make apply
```

Behavior:
- Runs `terragrunt apply` in stack dependency order:
  1. `folder`
  2. `project`
  3. `network`
  4. `private-vm`
- Stops immediately on the first stack failure.

## Destroy
```bash
make destroy
```

Behavior:
- Requires two confirmations before any destroy command runs:
  1. Type `yes`.
  2. Type the repository name `iac-framework`.
- Runs `terragrunt destroy` in reverse order:
  1. `private-vm`
  2. `network`
  3. `project`
  4. `folder`
- Stops immediately on the first stack failure.

## Destroy VM
```bash
make destroy-vm
```

Behavior:
- Requires one confirmation before destroying the VM stack.
- Runs `terragrunt destroy` only in:
  - `terraform/terragrunt/development/private-vm`
- Use this when you want to recreate the VM without tearing down folder, project, or network stacks.

## SSH
```bash
make ssh
```

Behavior:
- Resolves `project_id` from the project Terragrunt stack output.
- Resolves `vm_name` from the private-vm Terragrunt stack output.
- Opens terminal access with:
  - `gcloud compute ssh --tunnel-through-iap`
- Uses `VM_ZONE` from Makefile (default `europe-west1-b`).
- Override zone when needed:
  - `make ssh VM_ZONE=europe-west1-c`

## Notes
- Apply and destroy remain human-run operations.
- Commands load values from `.env.local` in the same execution shell.
- If `ORGANIZATION_ID` or `BILLING_ACCOUNT` is missing or still placeholder, the command exits with an error.
- If `GOOGLE_APPLICATION_CREDENTIALS` is not set, the command exits with an error.
- If `VM_ACCESS_USER_EMAIL` is missing or still placeholder, the command exits with an error.
- If `ENABLE_PUBLIC_IP=true` and `USE_PUBLIC_SUBNET!=true`, the command exits with an error.
- Terragrunt environment inputs resolve from environment variables when provided (for example `ORGANIZATION_ID`, `BILLING_ACCOUNT`, `VM_ACCESS_USER_EMAIL`, and `MACHINE_TYPE`).
