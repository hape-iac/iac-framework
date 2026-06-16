locals {
  environment = "development"
  common_labels = {
    environment = "development"
    managed_by  = "terraform"
    project     = "hape-iac"
  }
}

inputs = {
  environment = local.environment
  labels      = local.common_labels

  organization_id      = get_env("ORGANIZATION_ID", "123456789012")
  billing_account      = get_env("BILLING_ACCOUNT", "000000-000000-000000")
  vm_access_user_email = get_env("VM_ACCESS_USER_EMAIL", get_env("ACCESS_USER_EMAIL", "user@example.com"))

  region            = "europe-west1"
  zone              = "europe-west1-b"
  machine_type      = get_env("MACHINE_TYPE", "e2-micro")
  enable_cloud_nat  = false
  enable_public_ip  = tobool(get_env("ENABLE_PUBLIC_IP", "false"))
  use_public_subnet = tobool(get_env("USE_PUBLIC_SUBNET", "false"))

  folder_display_name = "hape-iac-development"
  project_name_prefix = "hape-iac-dev"

  network_name        = "hape-iac-dev-vpc"
  private_subnet_name = "workload-private-euw1"
  private_subnet_cidr = "10.42.0.0/24"
  public_subnet_name  = "ingress-public-euw1"
  public_subnet_cidr  = "10.42.1.0/24"
  ssh_target_tag      = "iap-ssh"

  vm_name = "hape-iac-dev-vm"
}
