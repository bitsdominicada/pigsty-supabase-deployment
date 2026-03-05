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
| 3 | `harden` | UFW, fail2ban, SSH hardening on all nodes |
| 4 | `verify` | Health checks and smoke tests |

Or run everything at once: `./v2/bin/pigsty-v2 deploy`

---

## Quick Start

### 0. Prerequisites

- macOS or Linux with `bash`, `curl`, `terraform`, `ssh`
- A cloud provider account (Vultr, Hetzner, DigitalOcean, etc.)
- A domain managed on Cloudflare (for DNS + SSL)

### 1. Configure credentials

```bash
cp v2/.env.example v2/.env
# Fill ALL required variables (the validator will tell you what's missing)
```

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

### 3. Deploy everything

```bash
./v2/bin/pigsty-v2 deploy
```

Or run phases individually:

```bash
./v2/bin/pigsty-v2 validate   # Phase 1: check config
./v2/bin/pigsty-v2 install    # Phase 2a: Pigsty + PG
./v2/bin/pigsty-v2 supabase   # Phase 2b: Supabase containers
./v2/bin/pigsty-v2 functions deploy --source /abs/path/to/supabase/functions
./v2/bin/pigsty-v2 functions smoke
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
| Backups | pgBackRest → Backblaze B2 (AES-256, incremental) |
| Monitoring | Grafana + vmalert + node_exporter + pg_exporter |
| Security | UFW, fail2ban, SSH key-only, kernel hardening |
| DNS | Cloudflare automation |

## Supported Providers

Hetzner, DigitalOcean, Vultr, AWS, GCP, Azure, Linode, Aliyun, Qcloud.

Pull any provider's template:

```bash
./v2/bin/pigsty-v2 provider pull hetzner v4.2.0
./v2/bin/pigsty-v2 provider use hetzner
```
