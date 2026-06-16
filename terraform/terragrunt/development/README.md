# Development Terragrunt Environment

This directory is the only runnable environment in Milestone 1.
Stack order is:
1. `folder`
2. `project`
3. `network`
4. `private-vm`

Run `terragrunt init`, `terragrunt validate`, and `terragrunt plan` in each stack directory.
Keep `apply` and `destroy` as manual-only operations.
