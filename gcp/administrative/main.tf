# resource "google_project_iam_member" "assign_user" {
#   for_each = toset(var.participants)
#   project = var.project_id
#   role    = "roles/compute.instanceAdmin.v1"
#   member  = each.key
# }

# resource "google_project_iam_custom_role" "vm_creator" {
#   role_id     = "vmCreator"
#   title       = "VM Creator"
#   description = "Can create and start VM instances only"
#   project     = "your-project-id"

#   permissions = [
#     "compute.instances.create",
#     "compute.instances.start",
#     "compute.instances.get",
#     "compute.zones.list"
#   ]
# }

# resource "google_project_iam_member" "custom_vm_creator_assignment" {
#   project = var.project_id
#   role    = google_project_iam_custom_role.vm_creator.name
#   member  = "user:user@example.com"
# }