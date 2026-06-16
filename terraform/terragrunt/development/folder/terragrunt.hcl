include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/gcp/folder"
}

inputs = merge(
  local.env.inputs,
  {
    organization_id     = local.env.inputs.organization_id
    folder_display_name = local.env.inputs.folder_display_name
  }
)
