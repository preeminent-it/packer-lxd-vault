# Packer LXD - Hashicorp Vault

## Build
```bash
packer build .
```

## Requirements

* packer 1.6.6 (or earlier supporting hcl2)
* a working lxd installation

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| source | Variables | `map(string)` | <pre>{<br>  "description": "Hashicorp Vault- Ubuntu 20.04",<br>  "image": "base-ubuntu-focal",<br>  "name": "vault-ubuntu-focal"<br>}</pre> | no |
| vault\_home | n/a | `string` | `"/opt/vault"` | no |
| vault\_user | n/a | `string` | `"vault"` | no |
