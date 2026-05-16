# hashicorp-vault

HashiCorp Vault deployed on Docker Swarm, fronted by Traefik with Let's Encrypt + Cloudflare DNS for automated TLS.

The repo has two independent layers:

- **`infrastructure/`** — Terraform that provisions an Ubuntu VM on Proxmox (cloud-init based), which hosts the Swarm node.
- **`ansible/`** — Ansible that installs Docker Swarm, deploys Traefik, and deploys Vault.

You can use both together, or skip Terraform and point Ansible at a VM you already have.

---

## Prerequisites

- Ansible 2.14+ and `ansible-galaxy`
- (Terraform path only) Terraform 1.5+ and a Proxmox node with an API token + a cloud-init template VM
- A Cloudflare account + API token with DNS edit permissions for your domain
- SSH access to the target host as a sudo-capable user

---

## Option A — Full deploy (Terraform → Ansible)

Provisions the VM on Proxmox, then configures it.

```bash
# 1. Copy the variable templates
cd infrastructure
cp vars/production.tfvars.example vars/production.tfvars
cp id_ed25519.pub.example id_ed25519.pub  # or replace with your real public key
```

You'll need to edit `vars/production.tfvars` to set your Proxmox URL, API token, and VM specs.

```bash
# 2. Provision the VM
terraform init
terraform apply -var-file=vars/production.tfvars
```

Then configure Ansible (see Option B steps 1–3) and run the playbook.

---

## Option B — Ansible only (bring your own host)

Use this if your VM/server already exists.

```bash
cd ansible

# 1. Install role and collection dependencies
ansible-galaxy role install -r ./roles/requirements.yml
```

**2.** You'll need to edit `inventories/production/hosts` to set `ansible_host` and `ansible_user` for your target machine.

**3.** Copy the secret templates, then edit each one with your real values:

```bash
cp inventories/production/group_vars/docker_swarm_manager/traefik.yml.example \
   inventories/production/group_vars/docker_swarm_manager/traefik.yml
cp inventories/production/group_vars/docker_swarm_manager/vault.yml.example \
   inventories/production/group_vars/docker_swarm_manager/vault.yml
```

- Edit `traefik.yml` — Cloudflare API token, admin credentials, your domain
- Edit `vault.yml` — your Vault URL

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

- `*.tfvars`, `traefik.yml`, and `vault.yml` are gitignored. Only the `.example` templates are committed.
- Never commit your Cloudflare API token, Proxmox API token, or unsealed Vault keys.
