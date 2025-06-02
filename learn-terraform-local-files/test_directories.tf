
# https://developer.hashicorp.com/terraform/language/resources/terraform-data
resource "terraform_data" "create_directory" {
  provisioner "local-exec" {
    command = "powershell -ExecutionPolicy Bypass -File ${path.module}/create_directory.ps1"
    when    = create
  }
}

resource "terraform_data" "delete_directory" {
  provisioner "local-exec" {
    when    = destroy
    command = "powershell -ExecutionPolicy Bypass -File ${path.module}/delete_directory.ps1"
  }
}
