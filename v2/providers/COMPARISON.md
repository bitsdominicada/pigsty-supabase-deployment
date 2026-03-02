# Cloud Template Comparison (Pigsty v4.2.0)

Reference:
- https://github.com/pgsty/pigsty/tree/v4.2.0/terraform/spec
- https://github.com/pgsty/pigsty/blob/v4.2.0/terraform/README.md

## Quick summary

- **Hetzner**: best cost/performance baseline for a single-node lab/staging environment.
- **DigitalOcean**: simpler provider experience, but significantly higher monthly cost for similar size.
- **AWS/GCP/Azure**: better enterprise ecosystem and integrations, higher complexity and cost.

## What the official templates already provide

Common pattern across provider templates:
- 1-node `pg-meta` VM.
- Debian image defaults (`d12`, optional `d13`).
- Private networking plus public IP.
- SSH key bootstrap from `~/.ssh/id_rsa.pub`.
- Broad firewall rules (demo-friendly, not production-safe).

## Hetzner template (highlights)

File: `terraform/spec/hetzner.tf`
- Architecture switch (`amd64` / `arm64`).
- Explicit private IP assignment (`10.10.10.10`).
- Built-in firewall resource attached to server.
- Lowest cost profile in upstream docs.

## DigitalOcean template (highlights)

File: `terraform/spec/digitalocean.tf`
- Region-based droplet deployment.
- VPC + reserved public IP pattern.
- Firewall bound to droplet ID.
- No ARM toggle in the upstream template.

## Gaps we should close in V2 before production

- Replace "allow all" firewall rules with least privilege.
- Enforce SSH host key verification in operational scripts.
- Add explicit backup/restore validation after deploy.
- Add policy checks for exposed ports and CIDR ranges.

