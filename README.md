# Pigsty Supabase Deployment

Automated deployment of **Supabase** with **PostgreSQL 17** using **Pigsty**, from macOS to VPS.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/bitsdominicada/pigsty-supabase-deployment.git
cd pigsty-supabase-deployment

# 2. Generate configuration
./scripts/generate-secrets

# 3. Deploy (single command)
./scripts/deploy-simple all
```

**Duration:** ~20 minutes

---

## Features

- **PostgreSQL 17** with 400+ extensions
- **Supabase** full stack (Auth, Storage, Realtime, Functions, Studio)
- **High Availability** with Patroni + etcd
- **Monitoring** with Prometheus + Grafana
- **HTTPS** with Let's Encrypt (automatic)
- **Backblaze B2** support for Supabase Storage
- **100% automated** from macOS

---

## Architecture

```
┌─────────────────────────────────┐
│  macOS (Control)                │
│  └─ ./scripts/deploy-simple    │
└──────────────┬──────────────────┘
               │ SSH
               ↓
┌─────────────────────────────────┐
│  VPS (Ubuntu 24.04)             │
│                                  │
│  ┌────────────────────────────┐ │
│  │ Pigsty v3.6.1              │ │
│  │ ├─ PostgreSQL 17 + Patroni │ │
│  │ ├─ HAProxy + pgbouncer     │ │
│  │ └─ Grafana + Prometheus    │ │
│  └────────────────────────────┘ │
│                                  │
│  ┌────────────────────────────┐ │
│  │ Supabase (Docker)          │ │
│  │ ├─ Kong (API Gateway)      │ │
│  │ ├─ Auth + Storage          │ │
│  │ ├─ Realtime + REST         │ │
│  │ └─ Studio (Dashboard)      │ │
│  └────────────────────────────┘ │
└─────────────────────────────────┘
```

---

## Requirements

### macOS
- Homebrew
- `sshpass`: `brew install hudochenkov/sshpass/sshpass`

### VPS
- Ubuntu 22.04/24.04
- 4GB+ RAM (8GB recommended)
- 2+ CPU cores
- 40GB+ SSD
- Root SSH access

---

## Configuration

### Interactive (Recommended)

```bash
./scripts/generate-secrets
```

Generates all passwords, JWT tokens, and optionally configures:
- Domain + Let's Encrypt SSL
- Backblaze B2 for storage
- SMTP for emails

### Manual

```bash
cp .env.example .env
# Edit .env with your values
```

---

## Deployment

### Full Deployment

```bash
./scripts/deploy-simple all
```

This will:
1. Prepare VPS (user, SSH keys, dependencies)
2. Download and configure Pigsty v3.6.1
3. Generate `pigsty.yml` with your settings
4. Run `install.yml` (PostgreSQL, monitoring)
5. Run `docker.yml` (Docker installation)
6. Run `app.yml` (Supabase containers)
7. Apply Backblaze B2 fixes (if configured)
8. Display access credentials

### Other Commands

```bash
./scripts/deploy-simple config    # Generate and upload pigsty.yml only
./scripts/deploy-simple validate  # Validate configuration
./scripts/deploy-simple verify    # Check deployment status
```

---

## Access Points

After deployment, you'll see:

| Service | URL | Credentials |
|---------|-----|-------------|
| Supabase Studio | `https://your-domain.com` | From `.env` |
| Grafana | `http://VPS_IP` | `admin` / from `.env` |
| PostgreSQL | `VPS_IP:5436` | `supabase_admin` / from `.env` |

---

## Project Structure

```
pigsty-supabase-deployment/
├── scripts/
│   ├── deploy-simple       # Main deployment script
│   ├── generate-secrets    # Configuration generator
│   └── modules/
│       ├── 01-prepare.sh   # VPS preparation
│       └── 03-validate.sh  # Configuration validation
├── lib/
│   └── simple-yaml-gen.py  # YAML generator with automatic fixes
├── .env.example            # Configuration template
└── README.md
```

---

## How It Works

This project follows **Pigsty's official deployment flow**:

```bash
# What deploy-simple does internally:
curl https://repo.pigsty.io/get | bash     # Download Pigsty
./bootstrap                                  # Install Ansible
./configure -c supabase                      # Use supabase template
# Upload customized pigsty.yml
./install.yml                                # PostgreSQL + infra
./docker.yml                                 # Docker
./app.yml                                    # Supabase containers
```

### Automatic Fixes Applied

The `simple-yaml-gen.py` script automatically applies fixes learned from production:

1. **pg_hba.conf rules** - Adds VPS IP for HAProxy connections
2. **Docker gateway IP** - Uses `172.17.0.1` for container connectivity
3. **Backblaze B2 compatibility** - Adds `TUS_ALLOW_S3_TAGS=false`
4. **Safe passwords** - Generates alphanumeric-only passwords (no URL encoding issues)
5. **Inline comments removal** - Prevents Docker from including comments in values

---

## Backblaze B2 Storage

To use Backblaze B2 instead of MinIO:

1. Create a B2 bucket
2. Create an application key with read/write access
3. Run `./scripts/generate-secrets` and enter B2 credentials when prompted

The script will automatically configure:
- S3-compatible endpoint
- `TUS_ALLOW_S3_TAGS=false` for compatibility

---

## Troubleshooting

### SSH Connection Issues

```bash
# Remove old host key after VPS reinstall
ssh-keygen -R YOUR_VPS_IP

# Test connection
source .env && sshpass -p "${VPS_ROOT_PASSWORD}" ssh root@${VPS_HOST} "hostname"
```

### Check Container Status

```bash
source .env && ssh deploy@${VPS_HOST} "docker ps --format 'table {{.Names}}\t{{.Status}}'"
```

### View Container Logs

```bash
source .env && ssh deploy@${VPS_HOST} "cd /opt/supabase && docker compose logs storage"
```

### PostgreSQL Connection Test

```bash
source .env && PGPASSWORD="${POSTGRES_PASSWORD}" psql -h ${VPS_HOST} -p 5436 -U supabase_admin -d postgres -c "SELECT version();"
```

---

## License

AGPLv3 (inherited from Pigsty)

---

## Credits

- [Pigsty](https://github.com/pgsty/pigsty) - PostgreSQL distribution
- [Supabase](https://github.com/supabase/supabase) - Open source Firebase alternative

---

**Made with care for the PostgreSQL community**
