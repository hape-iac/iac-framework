resource "google_service_account" "vm" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}

resource "google_project_iam_member" "vm_service_account_roles" {
  for_each = toset(var.service_account_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.vm.email}"
}

resource "google_project_iam_member" "iap_tunnel_user" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "user:${var.vm_access_user_email}"
}

resource "google_project_iam_member" "os_login_user" {
  project = var.project_id
  role    = "roles/compute.osLogin"
  member  = "user:${var.vm_access_user_email}"
}

resource "google_project_iam_member" "compute_viewer_user" {
  count = var.grant_compute_viewer_role ? 1 : 0

  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "user:${var.vm_access_user_email}"
}

resource "google_compute_instance" "this" {
  project      = var.project_id
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = [var.ssh_target_tag]
  labels       = var.instance_labels

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.boot_disk_size_gb
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link

    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []
      content {}
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email = google_service_account.vm.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  depends_on = [
    google_project_iam_member.vm_service_account_roles,
    google_project_iam_member.iap_tunnel_user,
    google_project_iam_member.os_login_user
  ]
}
