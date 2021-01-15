// Image
source "lxd" "main" {
  image        = "${var.source.image}"
  output_image = "${var.source.name}"
  publish_properties = {
    description = "${var.source.description}"
  }
}

// Build
build {
  sources = ["source.lxd.main"]

  // Create self-signed certificate
  provisioner "shell" {
    inline = [
      "openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout /etc/vault/tls/server.key -out /etc/vault/tls/server.crt -subj \"/CN=vault\""
    ]
  }

  // Add Vault config
  provisioner "file" {
    source      = "files/etc/vault"
    destination = "/etc/"
  }

  // Add Vault service
  provisioner "file" {
    source      = "files/etc/systemd/system/vault.service"
    destination = "/etc/systemd/system/vault.service"
  }

  // Set file ownership and enable the service
  provisioner "shell" {
    inline = [
      "chown -R ${var.vault_user} /etc/vault ${var.vault_home}",
      "systemctl enable vault"
    ]
  }
}
