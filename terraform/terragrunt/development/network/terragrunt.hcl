include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/gcp/network"
}

dependency "project" {
  config_path = "../project"
  mock_outputs = {
    project_id = "hape-iac-dev-0000"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "state", "output"]
}

inputs = merge(
  local.env.inputs,
  {
    project_id          = dependency.project.outputs.project_id
    region              = local.env.inputs.region
    network_name        = local.env.inputs.network_name
    private_subnet_name = local.env.inputs.private_subnet_name
    private_subnet_cidr = local.env.inputs.private_subnet_cidr
    public_subnet_name  = local.env.inputs.public_subnet_name
    public_subnet_cidr  = local.env.inputs.public_subnet_cidr
    enable_cloud_nat    = local.env.inputs.enable_cloud_nat
    ssh_target_tag      = local.env.inputs.ssh_target_tag
  }
)
