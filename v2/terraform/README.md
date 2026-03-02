# Terraform Workspace (V2)

This directory is the isolated Terraform workspace for the new v2 deployment flow.

Workflow:

```bash
cp v2/.env.example v2/.env
# Set provider token in v2/.env (example: VULTR_API_KEY=...)

./v2/bin/pigsty-v2 provider pull hetzner v4.2.0
./v2/bin/pigsty-v2 provider use hetzner
./v2/bin/pigsty-v2 iac init
./v2/bin/pigsty-v2 iac plan
./v2/bin/pigsty-v2 iac apply
```

Examples for provider credentials (if exporting manually):

```bash
# Hetzner
export HCLOUD_TOKEN="<token>"

# DigitalOcean
export DIGITALOCEAN_TOKEN="<token>"
```

The wrapper loads `v2/.env` automatically before running commands.

Notes:
- Upstream templates are demo-friendly and commonly open all ports.
- Before production use, restrict firewall/security-group rules.
