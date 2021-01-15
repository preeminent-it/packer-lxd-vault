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
