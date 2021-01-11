// Variables
variable "packages" {
  type    = list(string)
  default = [
    "curl",
    "unzip"
  ]
}

variable "vault_home" {
  type    = string
  default = "/opt/vault"
}

variable "vault_version" {
  type    = string
  default = "1.6.1"
}

variable "vault_user" {
  type    = string
  default = "vault"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

// Image
source "lxd" "vault-ubuntu-focal" {
  image        = "images:ubuntu/focal"
  output_image = "vault-ubuntu-focal"
  publish_properties = {
    description = "Hashicorp Vault - Ubuntu Focal"
  }
}

// Build
build {
  sources = ["source.lxd.vault-ubuntu-focal"]

  provisioner "shell" {
    inline = [
      "apt-get update -qq",
      "DEBIAN_FRONTEND=noninteractive apt-get install -qq ${join(" ", var.packages)} < /dev/null > /dev/null"
    ]
  }

  provisioner "shell" {
    inline = ["mkdir -p /etc/vault/tls /opt/vault/raft"]
  }

  provisioner "shell" {
    inline = ["openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout /etc/vault/tls/server.key -out /etc/vault/tls/server.crt -subj \"/CN=vault\""]
  }

  provisioner "shell" {
    inline = ["curl -sO https://releases.hashicorp.com/vault/${var.vault_version}/vault_${var.vault_version}_linux_amd64.zip &&",
      "unzip vault_${var.vault_version}_linux_amd64.zip vault -d /usr/local/bin/ &&",
      "rm vault_${var.vault_version}_linux_amd64.zip"
    ]
  }

  provisioner "shell" {
    inline = ["useradd --system --home ${var.vault_home} --shell /bin/false ${var.vault_user}",
      "setcap cap_ipc_lock=+ep /usr/local/bin/vault"
    ]
  }

  provisioner "file" {
    source      = "files/etc/vault/vault.hcl"
    destination = "/etc/vault/vault.hcl"
  }

  provisioner "file" {
    source      = "files/etc/systemd/system/vault.service"
    destination = "/etc/systemd/system/vault.service"
  }

  provisioner "shell" {
    inline = ["chown -R ${var.vault_user} /etc/vault /opt/vault",
              "systemctl enable vault"
             ]
  }
}
