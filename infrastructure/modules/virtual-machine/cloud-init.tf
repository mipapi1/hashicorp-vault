data "local_file" "ssh_public_key" {
  filename = "./id_ed25519.pub"
}

# Cloud-init user-data file (must use file-based datastore, e.g., 'local')
resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.cloud_init_datastore_id     
  node_name    = var.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: vault-prod01
    timezone: America/New_York
    users:
      - default
      - name: papi
        groups:
          - sudo
          - _ssh
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(data.local_file.ssh_public_key.content)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}

# Download Cloud Image
resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "import"
  datastore_id = var.cloud_init_datastore_id         
  node_name    = var.node_name
  url          = var.cloud_init_image_url
  checksum_algorithm = "sha256"
  checksum     = var.cloud_init_image_checksum
  file_name    = var.cloud_init_image_file_name
}
