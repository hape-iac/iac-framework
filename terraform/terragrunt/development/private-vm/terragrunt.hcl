include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/gcp/private-vm"
}

dependency "project" {
  config_path = "../project"
  mock_outputs = {
    project_id = "hape-iac-dev-0000"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "state", "output"]
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    private_subnet_self_link = "projects/hape-iac-dev-0000/regions/europe-west1/subnetworks/workload-private-euw1"
    public_subnet_self_link  = "projects/hape-iac-dev-0000/regions/europe-west1/subnetworks/ingress-public-euw1"
    ssh_target_tag           = "iap-ssh"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "state", "output"]
}

inputs = merge(
  local.env.inputs,
  {
    project_id           = dependency.project.outputs.project_id
    zone                 = local.env.inputs.zone
    vm_name              = local.env.inputs.vm_name
    machine_type         = local.env.inputs.machine_type
    enable_public_ip     = local.env.inputs.enable_public_ip
    subnet_self_link     = local.env.inputs.use_public_subnet ? try(dependency.network.outputs.public_subnet_self_link, dependency.network.outputs.subnet_self_link) : try(dependency.network.outputs.private_subnet_self_link, dependency.network.outputs.subnet_self_link)
    ssh_target_tag       = dependency.network.outputs.ssh_target_tag
    vm_access_user_email = local.env.inputs.vm_access_user_email
    instance_labels      = local.env.inputs.labels
  }
)
