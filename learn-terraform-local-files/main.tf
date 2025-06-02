# resource "null_resource" "files_directory" {
#   provisioner "local-exec" {
#     command = "powershell "
#   }
# }

# resource "null_resource" "remove_files_directory" {
#     provisioner "local-exec" {
#         command = "powershell -Command Remove-Item -Path ${path.module}/files -Recurse -Force"
#         when = destroy
#     }
# }

resource "local_file" "many_files" {
  for_each = { for index, file in var.listOfObjects : "${index}-${file.name}" => file
  }
  filename = "${path.module}/files/file-${each.key}.txt"
  content  = each.value.content
}

locals {
  files = { for index, file in var.listOfObjects : "${index}-locals-${file.name}" => file }
}

resource "local_file" "other_approach" {
  for_each = local.files
  filename = "${path.module}/files/${each.key}.txt"
  content = each.value.content
}