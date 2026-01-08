# Pigsty Supabase

Single-command deployment of **Supabase** with **PostgreSQL 18** using [Pigsty](https://github.com/pgsty/pigsty).

```bash
./deploy
```

**Duration:** ~25 minutes

---

## What You Get

| Component | Version |
|-----------|---------|
| PostgreSQL | 18.1 |
| Pigsty | 4.0.0-c1 |
| Supabase | Latest |
| Monitoring | VictoriaMetrics + Grafana |

**Features:**
- Patroni HA (automatic failover)
- Backups to Backblaze B2 (daily, encrypted)
- SSL with Let's Encrypt
- UFW + Fail2ban security
- Health endpoint for monitoring

---

## Quick Start

```bash
# Clone
git clone https://github.com/bitsdominicada/pigsty-supabase-deployment.git
cd pigsty-supabase-deployment

# Deploy
./deploy
```

The wizard will ask for:
- VPS IP address
- Client name (for subdomain)
- Backblaze B2 credentials (optional)
- SMTP settings (optional)

---

## Commands

```bash
./deploy              # Full deployment
./deploy setup        # Only configure
./deploy install      # Only install Pigsty
./deploy supabase     # Only launch containers
./deploy harden       # Only security setup
./deploy status       # Check what's running
```

---

## Requirements

**VPS:**
- Ubuntu 22.04 or 24.04
- 4GB+ RAM (8GB recommended)
- 2+ CPU cores
- 40GB+ disk
- SSH key access

**Local:**
- macOS or Linux
- SSH client

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  VPS (Ubuntu)                                               │
│                                                              │
│  ┌───────────────────┐  ┌───────────────────────────────┐   │
│  │ Pigsty            │  │ Supabase (Docker)             │   │
│  │ ├─ PostgreSQL 18  │  │ ├─ Kong (API Gateway)         │   │
│  │ ├─ Patroni HA     │  │ ├─ GoTrue (Auth)              │   │
│  │ ├─ etcd           │  │ ├─ Storage API                │   │
│  │ ├─ pgBackRest     │  │ ├─ Realtime                   │   │
│  │ └─ Grafana        │  │ ├─ PostgREST                  │   │
│  └───────────────────┘  │ ├─ Edge Functions             │   │
│                          │ └─ Studio                     │   │
│                          └───────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## URLs

After deployment:

| Service | URL |
|---------|-----|
| App | `https://client.domain.com` |
| API | `https://api.client.domain.com` |
| Studio | `https://studio.client.domain.com` |
| Grafana | `https://grafana.client.domain.com` |
| Health | `http://VPS_IP:8080/health` |

---

## How It Works

This project uses the **official Pigsty flow** with minimal modifications:

```bash
# What ./deploy does internally:

# 1. Generate configuration
#    Creates .env and pigsty.yml with your settings

# 2. Install Pigsty
curl -fsSL https://repo.pigsty.io/get | bash
./deploy.yml    # PostgreSQL, Patroni, Grafana, Docker

# 3. Launch Supabase
./app.yml -e app=supabase

# 4. Harden
#    SSL, Firewall, Health endpoint
```

**Key difference from v1:** We don't modify Pigsty playbooks. We only generate a customized `pigsty.yml` and run official commands.

---

## Backups

Automated daily backups to Backblaze B2:

| Setting | Value |
|---------|-------|
| Schedule | Daily 2:00 AM |
| Retention | 14 days |
| Encryption | AES-256-CBC |
| Compression | LZ4 |

```bash
# Check backup status
ssh ubuntu@VPS "sudo -u postgres pgbackrest --stanza=pg-meta info"

# Manual backup
ssh ubuntu@VPS "sudo -u postgres pgbackrest --stanza=pg-meta --type=full backup"
```

---

## License

Apache-2.0

---

## Credits

- [Pigsty](https://github.com/pgsty/pigsty) - PostgreSQL distribution
- [Supabase](https://github.com/supabase/supabase) - Open source Firebase alternative
