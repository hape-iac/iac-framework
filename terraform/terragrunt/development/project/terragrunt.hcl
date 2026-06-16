include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/gcp/project"
}

dependency "folder" {
  config_path = "../folder"
  mock_outputs = {
    folder_id = "1234567890"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "state", "output"]
}

inputs = merge(
  local.env.inputs,
  {
    folder_id           = dependency.folder.outputs.folder_id
    billing_account     = local.env.inputs.billing_account
    project_name_prefix = local.env.inputs.project_name_prefix
    project_labels      = local.env.inputs.labels
  }
)
