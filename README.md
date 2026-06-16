# IaC Framework

## Purpose
`iac-framework` contains the Terraform and Terragrunt source used to deliver the Milestone 1 golden path.

## Milestone 1 Scope
- Create one GCP folder and one GCP project.
- Build custom VPC and private workload subnet.
- Create one private VM with no external IP.
- Support IAP and OS Login based SSH access.
- Keep Cloud NAT optional and disabled by default.

## Execution Model
- Terragrunt-only stack execution.
- Local backend state in `.state/` for learning workflows.
- Agent runs init/validate/plan only.
- Human runs apply/destroy manually.
- Pattern guidance is advisory: agents explain risks and ask before changing infrastructure behavior.

## Key Paths
- `terraform/modules/gcp/`: reusable module boundaries.
- `terraform/terragrunt/`: environment and stack wiring.
- `docs/`: architecture, inputs, validation, and operations notes.

## Getting Started
1. Initialize local workspace values:
   ```bash
   make init
   ```
2. Review available commands:
   ```bash
   make help
   ```
3. Preview infrastructure changes:
   ```bash
   make preview
   ```
4. Apply stacks in dependency order:
   ```bash
   make apply
   ```
5. Destroy stacks in reverse order:
   ```bash
   make destroy
   ```
6. Optional: destroy only the VM stack before recreating it:
   ```bash
   make destroy-vm
   ```
7. Open terminal access to the VM through IAP:
   ```bash
   make ssh
   ```

`make destroy` requires two verification steps:
- Type `yes`.
- Type the repository name `iac-framework`.

See `docs/makefile.md` for command behavior and safeguards.
