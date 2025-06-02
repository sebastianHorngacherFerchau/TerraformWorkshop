locals {
  service_accounts = { for participant in var.participants : participant.id => participant }
}

# Create a service account for each participant
resource "google_service_account" "participant_sa" {
  for_each     = local.service_accounts
  account_id   = "${each.value.id}-sa"
  display_name = "Workshop user ${each.key}"
}

resource "google_project_iam_member" "storage_admin_role" {
  for_each = local.service_accounts
  project  = var.project_id
  role     = "roles/storage.admin"
  member   = "serviceAccount:${google_service_account.participant_sa[each.key].email}"
}

# Assign IAM roles to each service account
resource "google_project_iam_member" "compute_instance_admin_role" {
  for_each = local.service_accounts
  project  = var.project_id
  role     = "roles/compute.instanceAdmin.v1"
  member   = "serviceAccount:${google_service_account.participant_sa[each.key].email}"
}

# Create service account key (JSON file)
resource "google_service_account_key" "participant_key" {
  for_each           = local.service_accounts
  service_account_id = google_service_account.participant_sa[each.key].id
  keepers = {
    user = each.key
  }
}

# Output key paths as files
resource "local_file" "participant_key_file" {
  for_each = local.service_accounts

  filename = "${path.module}/keys/${each.key}-key.json"
  content  = base64decode(google_service_account_key.participant_key[each.key].private_key)
}