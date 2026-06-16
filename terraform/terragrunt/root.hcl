locals {
  state_root = "${get_parent_terragrunt_dir()}/../../.state"
}

remote_state {
  backend = "local"
  config = {
    path = "${local.state_root}/${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {}
EOF
}
