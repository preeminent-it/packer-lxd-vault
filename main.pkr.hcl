// Variables
variable "source" {
  type = map(string)
  default = {
    description = "Hashicorp Vault- Ubuntu 20.04"
    image       = "base-ubuntu-focal"
    name        = "vault-ubuntu-focal"
  }
}

variable "vault_home" {
  type    = string
  default = "/opt/vault"
}

variable "vault_user" {
  type    = string
  default = "vault"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

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
    source      = "files/etc/vault/vault.hcl"
    destination = "/etc/vault/vault.hcl"
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

  // Disable Vault Agent
  provisioner "shell" {
    inline = [
      "systemctl disable vault-agent"
    ]
  }
}
