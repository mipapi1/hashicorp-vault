# hashicorp-vault

HashiCorp Vault deployed on Docker Swarm, fronted by Traefik with Let's Encrypt + Cloudflare DNS for automated TLS.

VM provisioning is handled by the standalone [proxmox-infrastructure](../proxmox-infrastructure) project. This repo covers only the Ansible layer that configures the host once it exists.

---

## VM Spec

| Field | Value |
|---|---|
| Name | `vault-prod01` |
| Node | `proxmox02` |
| IP | `10.42.1.36/22` |
| vCPU | 1 |
| Memory | 2048 MB |
| Disk | 64 GB |

---

## Prerequisites

- Ansible 2.14+ and `ansible-galaxy`
- A Cloudflare account + API token with DNS edit permissions for your domain
- SSH access to the target host as a sudo-capable user (`papi`)

---

## Deploy

```bash
cd ansible

# 1. Install role and collection dependencies
ansible-galaxy role install -r ./roles/requirements.yml
```

**2.** Edit `inventories/production/hosts` to set `ansible_host` and `ansible_user` for your target machine.

**3.** Copy the secret templates, then fill in your real values:

```bash
cp inventories/production/group_vars/docker_swarm_manager/traefik.yml.example \
   inventories/production/group_vars/docker_swarm_manager/traefik.yml
cp inventories/production/group_vars/docker_swarm_manager/vault.yml.example \
   inventories/production/group_vars/docker_swarm_manager/vault.yml
```

- `traefik.yml` — Cloudflare API token, admin credentials, your domain
- `vault.yml` — your Vault URL

```bash
# 4. Deploy
ansible-playbook -i inventories/production site.yml
```

> **Tip:** If you re-provisioned the VM and get an SSH host key error, clear the old key first:
> ```bash
> ssh-keygen -R <host-ip>
> ```

Run a single layer with tags: `--tags docker_swarm`, `--tags traefik`, or `--tags vault`.

---

## After deploy

Vault will be available at the `vault_config.url` you set in `vault.yml`, served via Traefik with a Let's Encrypt cert issued through the Cloudflare DNS-01 challenge.

Initialize and unseal as usual:

```bash
vault operator init
vault operator unseal
```

---

## Notes on secrets

- `traefik.yml` and `vault.yml` are gitignored. Only the `.example` templates are committed.
- Never commit your Cloudflare API token, Proxmox API token, or unsealed Vault keys.
