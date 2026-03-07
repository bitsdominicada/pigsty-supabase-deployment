# Pigsty Supabase V2

Reproducible deployment of **Supabase** on **PostgreSQL 18** with [Pigsty](https://github.com/pgsty/pigsty).

Separates concerns into sequential phases:

| Phase | Command | What it does |
|-------|---------|-------------|
| 0 | `iac init/plan/apply` | Provision cloud infra with Terraform |
| 1 | `validate` | Verify `.env` contract — all secrets present |
| 2a | `install` | Install Pigsty + PostgreSQL + Patroni HA |
| 2b | `supabase` | Deploy Supabase containers + SSL certs |
| 2c | `functions deploy` | Sync all Supabase Edge Functions from local repo to VPS |
| 2d | `migrations apply` | Apply app SQL migrations incrementally on current leader |
| 3 | `harden` | UFW, fail2ban, SSH hardening on all nodes |
| 4 | `verify` | Health checks and smoke tests |

Base platform rollout in one command: `./v2/bin/pigsty-v2 deploy`

---

## Quick Start

### 0. Prerequisites

- macOS or Linux with `bash`, `curl`, `terraform`, `ssh`
- A cloud provider account (Vultr, Hetzner, DigitalOcean, etc.)
- A domain managed on Cloudflare (for DNS + SSL)

Optional but recommended for admin access:
- Tailscale on your workstation and all three nodes

### 1. Configure credentials

```bash
cp v2/.env.example v2/.env
# Fill ALL required variables (the validator will tell you what's missing)
```

### 1b. Recommended admin path: Tailscale SSH

If `pg-meta` is already joined to your tailnet, switch the CLI to use it:

```bash
SSH_TRANSPORT=tailscale
TAILSCALE_META_HOST=pg-meta.your-tailnet.ts.net
```

You can verify the path with:

```bash
tailscale ping pg-meta.your-tailnet.ts.net
tailscale ssh root@pg-meta 'hostname'
```

Notes:
- The scripts still use `ssh`/`scp`/`rsync`, but they target your Tailscale host instead of the public IP.
- `db1` and `db2` switch to direct access when you set `TAILSCALE_DB1_HOST` / `TAILSCALE_DB2_HOST`.
- Once validated, you can close public SSH at the provider firewall and keep only Tailscale admin access.

### 2. Provision infrastructure

```bash
./v2/bin/pigsty-v2 provider pull vultr v4.2.0
./v2/bin/pigsty-v2 provider use vultr
./v2/bin/pigsty-v2 iac init
./v2/bin/pigsty-v2 iac plan
./v2/bin/pigsty-v2 iac apply
```

After `apply`, copy the IPs from Terraform output into `.env`:

```bash
./v2/bin/pigsty-v2 iac output
# Set META_IP, META_PRIVATE_IP, DB1_PRIVATE_IP, DB2_PRIVATE_IP in .env
```

### 3. Deploy base platform

```bash
./v2/bin/pigsty-v2 deploy
```

Then run app-specific phases explicitly:

```bash
./v2/bin/pigsty-v2 functions deploy --source /abs/path/to/supabase/functions
./v2/bin/pigsty-v2 functions smoke
./v2/bin/pigsty-v2 migrations status --source /abs/path/to/deployment/migrations
./v2/bin/pigsty-v2 migrations apply --source /abs/path/to/deployment/migrations
```

Or run phases individually:

```bash
./v2/bin/pigsty-v2 validate   # Phase 1: check config
./v2/bin/pigsty-v2 install    # Phase 2a: Pigsty + PG
./v2/bin/pigsty-v2 supabase   # Phase 2b: Supabase containers + DNS/certs
./v2/bin/pigsty-v2 harden     # Phase 3: security
./v2/bin/pigsty-v2 verify     # Phase 4: smoke tests
```

### 4. Verify

```bash
./v2/bin/pigsty-v2 verify
```

### 5. Check tooling

```bash
./v2/bin/pigsty-v2 doctor
```

### 6. Manual release workflow (GitHub Actions)

Use workflow `Deploy Supabase Edge Functions` and set:

- `app_ref`: branch or tag from `bits_flare_platform` (example: `main` or `v1.2.3`)
- `smoke_mode`: `safe` (recommended) or `live`
- `run_smoke`: `true` to validate after deploy

Required repository secrets:

- `BITS_PLATFORM_REPO_TOKEN` (read access to `bits_flare_platform`)
- `VPS_SSH_PRIVATE_KEY`
- `VPS_SSH_KNOWN_HOSTS` (pinned host key line)
- `V2_META_IP`
- `V2_SSH_USER`
- `V2_DOMAIN`
- `V2_API_SUBDOMAIN`
- `V2_ANON_KEY`
- `V2_SERVICE_ROLE_KEY`

---

## Project Structure

```
v2/
├── bin/
│   └── pigsty-v2              # CLI entrypoint
├── config/
│   ├── pigsty.yml.tpl         # Pigsty config template (envsubst)
│   └── supabase.env.tpl       # Supabase .env template (envsubst)
├── modules/
│   ├── validate.sh            # Phase 1: .env validation
│   ├── install.sh             # Phase 2a: Pigsty bootstrap + deploy
│   ├── supabase.sh            # Phase 2b: Docker + Supabase + SSL
│   ├── functions.sh           # Phase 2c: Edge Functions deploy + smoke tests
│   ├── migrations.sh          # Phase 2d: Incremental app SQL migrations
│   ├── harden.sh              # Phase 3: UFW, fail2ban, sysctl, SSH
│   └── verify.sh              # Phase 4: full health check report
├── providers/
│   └── terraform/             # Upstream Pigsty cloud templates
├── scripts/
│   └── fetch-provider-template.sh
├── terraform/                 # Active Terraform workspace
├── .env.example               # Full variable contract
└── .env                       # Your secrets (git-ignored)
```

## What Gets Deployed

| Component | Details |
|-----------|---------|
| PostgreSQL 18 | Pigsty-managed, Patroni HA (3-node cluster) |
| Supabase | Kong, GoTrue, Storage, Realtime, PostgREST, Studio, Analytics |
| Registry | Pigsty `registry` + `registry-ui` as private local image cache/hosting (`127.0.0.1:5000/5080`) |
| Reverse Proxy | Nginx with Let's Encrypt SSL |
| Backups | pgBackRest → Pigsty MinIO repo by default (AES-256, incremental) |
| Monitoring | Grafana + vmalert + node_exporter + pg_exporter |
| Security | UFW, fail2ban, SSH key-only, kernel hardening |
| DNS | Manual records or optional Cloudflare API upsert during `supabase` |

## Supported Providers

Hetzner, DigitalOcean, Vultr, AWS, GCP, Azure, Linode, Aliyun, Qcloud.

Pull any provider's template:

```bash
./v2/bin/pigsty-v2 provider pull hetzner v4.2.0
./v2/bin/pigsty-v2 provider use hetzner
```

## Remote Access Modes

- `SSH_TRANSPORT=direct`
  Uses `META_IP` exactly as before.
- `SSH_TRANSPORT=tailscale`
  Uses `TAILSCALE_META_HOST` for all admin operations against `pg-meta`.
  Replica operations switch to direct Tailscale access when `TAILSCALE_DB1_HOST` / `TAILSCALE_DB2_HOST` are set.

## DNS And Certificates

- `home`, `app`, `pos`, `ai`, `api`, and `studio` must resolve publicly to `META_IP` before Let's Encrypt can succeed.
- If `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ZONE_ID` are set, `./v2/bin/pigsty-v2 supabase` upserts those `A` records automatically.
- Without Cloudflare credentials, create those records manually in your DNS provider before running `supabase`.
