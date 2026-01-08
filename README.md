# Pigsty Supabase Deployment

Automated **single-command deployment** of **Supabase** with **PostgreSQL 18** using **Pigsty v3.7.0**, from macOS to VPS.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/bitsdominicada/pigsty-supabase-deployment.git
cd pigsty-supabase-deployment

# 2. Configure (interactive wizard)
./scripts/deploy-simple setup

# 3. Deploy everything
./scripts/deploy-simple all
```

**Duration:** ~25 minutes for complete deployment

---

## What You Get

A production-ready Supabase deployment with:

| Component | Description |
|-----------|-------------|
| PostgreSQL 18 | Latest version with 400+ extensions |
| Patroni HA | High availability with automatic failover |
| Supabase Stack | Auth, Storage, Realtime, Edge Functions, Studio |
| Backups to B2 | Automated daily backups to Backblaze B2 |
| SSL Certificates | Let's Encrypt with auto-renewal |
| Security | UFW Firewall + Fail2ban + SSH hardening |
| Monitoring | Grafana + Prometheus with alerts |
| Health Checks | HTTP endpoint + cron-based monitoring |
| Flutter Web | Automatic deployment of Flutter apps |

---

## Deployment Phases

When you run `./scripts/deploy-simple all`, the following phases execute automatically:

| Phase | Component | Condition |
|-------|-----------|-----------|
| 1 | Prepare VPS (user, SSH, dependencies) | Always |
| 2 | Wait for apt locks | Always |
| 3 | Install Pigsty (PostgreSQL 18, Patroni, Grafana) | Always |
| 4 | Install Docker | Always |
| 5 | Configure nginx SSL | Always |
| 6 | Launch Supabase (11 containers) | Always |
| 7 | Configure pgBackRest backups to B2 | If `PGBACKREST_ENABLED=true` |
| 8 | Restore database backups | If `db_backup/` exists |
| 9 | Multi-domain architecture + SSL | Always |
| 10 | Deploy Flutter Web app | If `FLUTTER_PROJECT_PATH` is set |
| 11 | Security hardening (UFW, Fail2ban, SSH) | Always |
| 12 | Health monitoring setup | Always |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  macOS (Control Machine)                                    │
│  └─ ./scripts/deploy-simple all                            │
└──────────────────────────┬──────────────────────────────────┘
                           │ SSH
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  VPS (Ubuntu 22.04/24.04)                                   │
│                                                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ Pigsty v3.7.0                                           ││
│  │ ├─ PostgreSQL 18 + Patroni (HA)                         ││
│  │ ├─ etcd (distributed consensus)                         ││
│  │ ├─ HAProxy + pgbouncer (connection pooling)             ││
│  │ └─ Grafana + Prometheus + Alertmanager                  ││
│  └─────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ Supabase (11 Docker Containers)                         ││
│  │ ├─ Kong (API Gateway) :8000/:8443                       ││
│  │ ├─ GoTrue (Auth) - JWT authentication                   ││
│  │ ├─ Storage API - S3-compatible file storage             ││
│  │ ├─ Realtime - WebSocket subscriptions                   ││
│  │ ├─ PostgREST - Auto-generated REST API                  ││
│  │ ├─ Edge Functions (Deno runtime)                        ││
│  │ ├─ Studio (Dashboard) :3001                             ││
│  │ ├─ postgres-meta - Database introspection               ││
│  │ ├─ Logflare (Analytics)                                 ││
│  │ ├─ Vector (Log aggregation)                             ││
│  │ └─ Imgproxy (Image transformations)                     ││
│  └─────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ Security                                                 ││
│  │ ├─ UFW Firewall (ports: 22, 80, 443, 3000, 3001, 8000)  ││
│  │ ├─ Fail2ban (SSH, nginx brute force protection)         ││
│  │ └─ SSH hardening (key-only, no root password)           ││
│  └─────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ Backups (pgBackRest → Backblaze B2)                     ││
│  │ ├─ Daily full backups at 2:00 AM                        ││
│  │ ├─ WAL archiving (point-in-time recovery)               ││
│  │ ├─ AES-256-CBC encryption                               ││
│  │ └─ 14-day retention                                      ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

---

## Multi-Domain Architecture

```
your-domain.com          → Flutter Web App (nginx)
api.your-domain.com      → Supabase API (Kong :8000)
studio.your-domain.com   → Supabase Studio (:3001)
grafana.your-domain.com  → Grafana Dashboard (:3000)
```

All domains share a single Let's Encrypt wildcard certificate.

---

## Requirements

### macOS (Control Machine)
- Homebrew
- SSH key pair (`~/.ssh/id_ed25519` or `~/.ssh/id_rsa`)

### VPS
- Ubuntu 22.04 or 24.04
- 4GB+ RAM (8GB recommended)
- 2+ CPU cores
- 40GB+ SSD
- SSH access (key-based recommended)

---

## Configuration

### Interactive Setup (Recommended)

```bash
./scripts/deploy-simple setup
```

This wizard configures:
- VPS connection (IP, SSH user/key)
- Domain and SSL settings
- Supabase credentials
- Backblaze B2 for backups
- SMTP for emails
- Flutter project path

### Manual Configuration

```bash
cp .env.example .env
# Edit .env with your values
```

### Key Environment Variables

```bash
# VPS Connection
VPS_HOST=your-vps-ip
SSH_USER=ubuntu

# Domain
SUPABASE_DOMAIN=your-domain.com
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=you@email.com

# Backblaze B2 Backups
PGBACKREST_ENABLED=true
PGBACKREST_S3_BUCKET=your-bucket
PGBACKREST_S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
PGBACKREST_S3_REGION=us-east-005
PGBACKREST_S3_ACCESS_KEY=your-key-id
PGBACKREST_S3_SECRET_KEY=your-secret
PGBACKREST_CIPHER_PASS=your-encryption-password

# Flutter (optional)
FLUTTER_PROJECT_PATH=/path/to/your/flutter/app

# Alerts
ALERT_EMAIL=alerts@your-domain.com
```

---

## Commands

### Deployment

```bash
./scripts/deploy-simple all        # Full deployment
./scripts/deploy-simple setup      # Interactive configuration
./scripts/deploy-simple verify     # Check deployment status
```

### Individual Components

```bash
./scripts/deploy-simple flutter    # Deploy Flutter Web app
./scripts/deploy-simple domains    # Configure domains + SSL
./scripts/deploy-simple security   # Apply security hardening
./scripts/deploy-simple health     # Setup health monitoring
```

### Backups

```bash
./scripts/deploy-simple backup     # Create database backup
./scripts/deploy-simple restore    # Restore database backup
```

### Schema Sync (Multi-environment)

```bash
./scripts/deploy-simple sync-schema ORIGIN_IP   # Sync schema from production
./scripts/deploy-simple apply-schema TARGET_IP  # Apply schema to target
./scripts/deploy-simple sync-all                # Sync schema + deploy Flutter
```

---

## Access Points

After deployment:

| Service | URL | Notes |
|---------|-----|-------|
| Flutter App | `https://your-domain.com` | Your web application |
| Supabase API | `https://api.your-domain.com` | REST/Realtime/Auth |
| Supabase Studio | `https://studio.your-domain.com` | Dashboard |
| Grafana | `https://grafana.your-domain.com` | Monitoring |
| Health Check | `http://VPS_IP:8080/health` | JSON status |
| Health Ping | `http://VPS_IP:8080/health/simple` | Returns "OK" |

### Default Credentials

Credentials are stored in `.env` and displayed after deployment:

- **Supabase Studio**: `DASHBOARD_USERNAME` / `DASHBOARD_PASSWORD`
- **Grafana**: `admin` / `GRAFANA_ADMIN_PASSWORD`
- **PostgreSQL**: `supabase_admin` / `POSTGRES_PASSWORD` on port `5436`

---

## Health Monitoring

### HTTP Endpoint

```bash
curl http://your-vps-ip:8080/health
```

Response:
```json
{
  "status": "healthy",
  "timestamp": "2026-01-07T03:04:26+00:00",
  "checks": {
    "postgres": "ok",
    "containers": "ok",
    "patroni": "ok"
  }
}
```

### Local Health Check

- **Script**: `/opt/supabase/health-check.sh`
- **Runs**: Every 5 minutes via cron
- **Logs**: `/var/log/supabase-health.log`
- **Alerts**: Email on failures (30-min cooldown)

Checks performed:
- PostgreSQL connectivity
- Patroni HA status
- Supabase container health
- Disk space (warning >80%, critical >90%)
- Memory usage (warning >85%, critical >95%)
- SSL certificate expiry (warning <14 days, critical <7 days)
- Replication lag (warning >1GB)

---

## Backups

### Automatic Backups

- **Schedule**: Daily at 2:00 AM UTC
- **Destination**: Backblaze B2 (S3-compatible)
- **Encryption**: AES-256-CBC
- **Retention**: 14 days
- **Compression**: LZ4 (~70% reduction)

### Manual Backup Commands

```bash
# On VPS - check backup status
sudo -u postgres pgbackrest --stanza=pg-meta info

# Run manual backup
sudo -u postgres pgbackrest --stanza=pg-meta --type=full backup

# Verify backup integrity
sudo -u postgres pgbackrest --stanza=pg-meta check
```

### Restore from Backup

```bash
# Stop PostgreSQL
sudo systemctl stop patroni

# Restore latest backup
sudo -u postgres pgbackrest --stanza=pg-meta --delta restore

# Start PostgreSQL
sudo systemctl start patroni
```

---

## Security

### Firewall (UFW)

Open ports:
- 22 (SSH)
- 80 (HTTP)
- 443 (HTTPS)
- 3000 (Grafana)
- 3001 (Supabase Studio)
- 8000 (Supabase API)
- 8080 (Health Check)
- 8443 (Supabase HTTPS)

### Fail2ban

Active jails:
- `sshd` - SSH brute force protection
- `nginx-http-auth` - HTTP auth failures
- `nginx-limit-req` - Rate limit violations
- `nginx-botsearch` - Bot/scanner detection

### SSH Hardening

- Password authentication disabled
- Root login disabled
- Key-based authentication only

---

## Grafana Alerts

Pre-configured alerts:

| Alert | Condition | Severity |
|-------|-----------|----------|
| PostgreSQL Down | Instance unreachable | Critical |
| High CPU Usage | >80% for 5 minutes | Warning |
| Disk Space Low | <20% free | Warning |

Alerts are sent to the configured email address (`ALERT_EMAIL`).

---

## Project Structure

```
pigsty-supabase-deployment/
├── scripts/
│   ├── deploy-simple              # Main deployment script
│   ├── setup-interactive.sh       # Configuration wizard
│   ├── utils.sh                   # Shared utilities
│   ├── cloudflare-dns.sh          # DNS automation
│   └── modules/
│       ├── 01-prepare.sh          # VPS preparation
│       ├── 03-validate.sh         # Configuration validation
│       ├── 10-restore-backup.sh   # Database restore
│       ├── 11-create-backup.sh    # Database backup
│       ├── 12-deploy-flutter-web.sh
│       ├── 13-configure-domains.sh
│       ├── 14-sync-app-schema.sh
│       ├── 15-apply-app-schema.sh
│       ├── 16-security-hardening.sh
│       └── 17-health-check.sh
├── lib/
│   └── inject-vars.py             # YAML variable injection
├── config/
│   └── app_schema/                # Schema sync files
├── db_backup/                     # Local backup storage
├── .env.example                   # Configuration template
└── README.md
```

---

## Troubleshooting

### SSH Connection Issues

```bash
# Remove old host key after VPS reinstall
ssh-keygen -R YOUR_VPS_IP

# Test connection
ssh -i ~/.ssh/id_ed25519 ubuntu@YOUR_VPS_IP "hostname"
```

### Check Container Status

```bash
ssh ubuntu@VPS_IP "docker ps --format 'table {{.Names}}\t{{.Status}}' | grep supabase"
```

### View Container Logs

```bash
ssh ubuntu@VPS_IP "cd /opt/supabase && docker compose logs -f auth"
```

### PostgreSQL Connection Test

```bash
PGPASSWORD="your-password" psql -h VPS_IP -p 5436 -U supabase_admin -d postgres -c "SELECT version();"
```

### Restart Supabase Stack

```bash
ssh ubuntu@VPS_IP "cd /opt/supabase && docker compose restart"
```

### Check Patroni Status

```bash
ssh ubuntu@VPS_IP "curl -s http://\$(hostname -I | awk '{print \$1}'):8008/"
```

### Verify Backups

```bash
ssh ubuntu@VPS_IP "sudo -u postgres pgbackrest --stanza=pg-meta info"
```

### Check Fail2ban Bans

```bash
ssh ubuntu@VPS_IP "sudo fail2ban-client status sshd"
```

---

## License

AGPLv3 (inherited from Pigsty)

---

## Credits

- [Pigsty](https://github.com/pgsty/pigsty) - PostgreSQL distribution
- [Supabase](https://github.com/supabase/supabase) - Open source Firebase alternative

---

**Single-command deployment for production-ready Supabase.**
