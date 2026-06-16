# IaC Framework Rules

## Scope
Applies to all paths under `iac-agent/iac-framework/`.

## Execution Rules
- Use Terragrunt for stack execution.
- Agent may run only `terragrunt init`, `terragrunt validate`, and `terragrunt plan`.
- Do not run apply or destroy from the agent.

## Safety Rules
- Keep local state under `.state/`.
- Keep credentials external using `GOOGLE_APPLICATION_CREDENTIALS`.
- Avoid committing secrets, state files, or tfvars containing sensitive values.
- Treat pattern guidance as advisory unless a deterministic Terraform or Terragrunt command check fails.
- Ask for explicit user approval before changing IAM, firewall, network, VM, access, or public IP behavior based on a recommendation.

## Milestone 1 Rules
- Development environment only.
- Region defaults to `europe-west1`.
- Cloud NAT defaults to disabled and is input-controlled.
- VM default machine type is `e2-micro` and must remain overridable.
- Custom VPC and approved Terragrunt stack composition are the recommendation baseline.
- Private VM mode is the default.
- Public IP mode is explicit user intent.
- IAP and OS Login are the recommended VM access model.
