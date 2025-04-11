resource "null_resource" "prepare_token" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/prepare-token.sh"
  }
}
