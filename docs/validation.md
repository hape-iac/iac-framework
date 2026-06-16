# Validation

## Deterministic Sequence
1. `terragrunt hcl format`
2. `terragrunt init`
3. `terragrunt validate`
4. `terragrunt plan`

Makefile shortcut from `iac-agent/iac-framework/`:
- `make preview`

## Expected Outcomes
- HCL formatting is consistent.
- Dependencies initialize without backend issues.
- Configuration validates without schema or reference errors.
- Plan output reflects expected folder, project, network, and VM resources.

## Execution Boundary
- Agent executes only validation commands.
- Human executes apply and destroy after review and approval.

## Advisory Pattern Review
- Pattern guidance is advisory and does not replace Terraform or Terragrunt validation.
- Review generated or existing IaC against the framework golden path before handoff.
- Surface recommendations for default network usage, public IP without clear intent, SSH exposure, missing IAP or OS Login, ad hoc resource composition, hardcoded values, cost, exposure, and operational complexity.
- Ask for explicit approval before changing Terraform, Terragrunt, IAM, firewall, network, VM, or access behavior based on a recommendation.
- Keep advisory recommendations separate from command validation evidence.
