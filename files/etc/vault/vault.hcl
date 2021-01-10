api_addr      = "https://0.0.0.0:8200"
cluster_addr  = "https://127.0.0.1:8201"
ui            = true
disable_mlock = true

listener "tcp" {
  address         = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_cert_file   = "/etc/vault/tls/server.crt"
  tls_key_file    = "/etc/vault/tls/server.key"
}

storage "raft" {
  path    = "/opt/vault"
  node_id = "vault"
}
