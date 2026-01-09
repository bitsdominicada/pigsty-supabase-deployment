# Pigsty Supabase Deployment

One-command deployment of **Supabase** with **PostgreSQL 18** using [Pigsty](https://github.com/pgsty/pigsty).

```bash
./deploy
```

**Duration:** ~25 minutes on a fresh VPS

---

## What You Get

| Component | Version |
|-----------|---------|
| PostgreSQL | 18 |
| Pigsty | 4.0.0 |
| Supabase | Latest |
| Monitoring | VictoriaMetrics + Grafana |

**Features:**
- Patroni HA (automatic failover)
- Encrypted backups to Backblaze B2 (pgBackRest)
- SSL certificates with Let's Encrypt
- Cloudflare DNS automation
- UFW + Fail2ban security
- SMTP via Resend (or any provider)
- Multi-client support (isolated stanzas per client)

---

## Quick Start

### 1. Clone

```bash
git clone https://github.com/bitsdominicada/pigsty-supabase-deployment.git
cd pigsty-supabase-deployment
```

### 2. Configure

```bash
cp .env.example .env
# Edit .env with your settings
```

**Required variables:**
```bash
VPS_HOST=your.vps.ip.address
CLIENT_NAME=clientname
SUPABASE_DOMAIN=clientname.yourdomain.com
```

**Optional (but recommended):**
```bash
# Backblaze B2 for backups and storage
S3_BUCKET=your-bucket
S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
S3_REGION=us-east-005
S3_ACCESS_KEY=your-key
S3_SECRET_KEY=your-secret

# SMTP for emails
SMTP_HOST=smtp.resend.com
SMTP_PORT=587
SMTP_USER=resend
SMTP_PASSWORD=re_xxxxx
SMTP_SENDER_NAME=YourApp
SMTP_ADMIN_EMAIL=noreply@yourdomain.com
```

### 3. Deploy

```bash
./deploy
```

That's it. The script handles everything:
- DNS records (Cloudflare)
- Pigsty + PostgreSQL 18
- Docker + Supabase containers
- SSL certificates
- pgBackRest backups to B2
- Security hardening

---

## Commands

```bash
./deploy              # Full deployment
./deploy setup        # Only configure (generate pigsty.yml)
./deploy install      # Only install Pigsty
./deploy supabase     # Only launch Supabase containers
./deploy harden       # Only security setup (SSL, firewall)
./deploy status       # Check deployment status
```

---

## Requirements

**VPS:**
- Ubuntu 22.04 or 24.04
- 4GB+ RAM (8GB recommended)
- 2+ CPU cores
- 40GB+ disk
- SSH key access (passwordless)

**Local:**
- macOS or Linux
- SSH client
- Cloudflare API token (for DNS automation)

---

## Architecture

```
                        Internet
                           │
                     ┌─────┴─────┐
                     │  Nginx    │ SSL termination
                     │  (Pigsty) │ Reverse proxy
                     └─────┬─────┘
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │ Studio   │    │   API    │    │   App    │
    │ :3001    │    │  :8000   │    │  (home)  │
    └──────────┘    └────┬─────┘    └──────────┘
                         │
              ┌──────────┴──────────┐
              │   Supabase Stack    │
              │  (Docker Compose)   │
              │                     │
              │  Kong, GoTrue,      │
              │  Storage, Realtime, │
              │  PostgREST, etc.    │
              └──────────┬──────────┘
                         │
              ┌──────────┴──────────┐
              │     PostgreSQL 18   │
              │       (Pigsty)      │
              │                     │
              │  Patroni HA         │
              │  pgBackRest → B2    │
              └─────────────────────┘
```

---

## URLs

After deployment:

| Service | URL |
|---------|-----|
| API | `https://api.{client}.{domain}` |
| Studio | `https://studio.{client}.{domain}` |
| App (Flutter) | `https://{client}.{domain}` |
| Grafana | `https://grafana.{client}.{domain}` |

---

## Backups

Automated backups to Backblaze B2 with pgBackRest:

| Setting | Value |
|---------|-------|
| Full backup | Sunday 1:00 AM |
| Diff backup | Mon-Sat 1:00 AM |
| Retention | 2 full + 7 diff |
| Encryption | AES-256-CBC |
| Compression | zstd |

Each client has its own stanza (`pg-{CLIENT_NAME}`), so multiple clients can share the same B2 bucket without conflicts.

```bash
# Check backup status
ssh ubuntu@VPS "sudo -u postgres pgbackrest --stanza=pg-{CLIENT_NAME} info"

# Manual full backup
ssh ubuntu@VPS "sudo -u postgres pgbackrest --stanza=pg-{CLIENT_NAME} --type=full backup"
```

---

## Multi-Client Deployment

Each client gets:
- Unique PostgreSQL cluster: `pg-{CLIENT_NAME}`
- Unique pgBackRest stanza in B2
- Separate DNS records
- Isolated Supabase instance

To deploy a new client:

```bash
# Copy and edit .env for new client
cp .env .env.newclient
# Edit: VPS_HOST, CLIENT_NAME, SUPABASE_DOMAIN

# Deploy
./deploy
```

---

## Troubleshooting

### Patroni not becoming Leader

If deploy fails at "Waiting for Patroni to become Leader":

```bash
# Check pgBackRest stanza
ssh ubuntu@VPS "sudo tail -20 /pg/log/postgres/*.log"

# If stanza mismatch, the deploy should auto-clean B2
# If not, manually clean:
ssh ubuntu@VPS "sudo -u postgres pgbackrest --stanza=pg-{CLIENT_NAME} stanza-delete --force"
ssh ubuntu@VPS "sudo -u postgres pgbackrest --stanza=pg-{CLIENT_NAME} stanza-create"
ssh ubuntu@VPS "sudo systemctl kill patroni; sleep 3; sudo systemctl start patroni"
```

### DNS not resolving

Check Cloudflare API token permissions:
- Zone:DNS:Edit
- Include all zones (or specific zone)

### SSL certificate failed

Ensure DNS is propagated before SSL:
```bash
dig +short {client}.{domain}
# Should return VPS IP
```

---

## Project Structure

```
pigsty-supabase-deployment/
├── deploy                    # Main deployment script
├── .env.example              # Environment template
├── scripts/
│   ├── generate-config.sh    # Generates pigsty.yml
│   └── cloudflare-dns.sh     # DNS automation
├── config/
│   └── patches/
│       └── vault_encryption.sql  # pgsodium vault fix
└── docs/                     # Additional documentation
```

---

## License

Apache-2.0

---

## Credits

- [Pigsty](https://github.com/pgsty/pigsty) - PostgreSQL distribution
- [Supabase](https://github.com/supabase/supabase) - Open source Firebase alternative
