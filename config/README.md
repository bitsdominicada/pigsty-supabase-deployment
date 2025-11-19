# Configuration Management

This directory manages Pigsty configuration using a layered approach.

## Directory Structure

```
config/
├── templates/
│   ├── base.yml                    # Official Pigsty template (downloaded)
│   └── overrides/
│       ├── common.yml              # Shared across all environments
│       ├── production.yml          # Production-specific settings
│       ├── development.yml         # Development-specific settings
│       └── modules/
│           ├── infra.yml           # INFRA module customizations
│           ├── pgsql.yml           # PGSQL module customizations
│           ├── node.yml            # NODE module customizations
│           └── app.yml             # APP (Supabase) customizations
│
├── generated/                      # Auto-generated (gitignored)
│   ├── pigsty.yml                  # Final merged configuration
│   └── backups/
│       └── pigsty.yml.*            # Timestamped backups
│
├── patches/                        # Auto-generated patches
│   └── credentials.yml             # Generated from .env
│
└── environments/                   # Environment variables
    ├── production.env
    └── development.env
```

## Configuration Layers

Configurations are merged in this order:

```
1. base.yml               (Official Pigsty template)
2. overrides/common.yml   (Shared settings)
3. overrides/production.yml or development.yml
4. overrides/modules/*.yml (Module-specific)
5. patches/credentials.yml (Auto-generated from .env)
   ↓
   = config/generated/pigsty.yml (Final)
```

## Usage

### Sync Configuration

```bash
# Download current config from VPS
./scripts/deploy config:pull

# Upload local config to VPS
./scripts/deploy config:sync

# View differences
./scripts/deploy config:diff
```

### Apply Changes

```bash
# Apply all changes (auto-detects what changed)
./scripts/deploy apply

# Apply specific module
./scripts/deploy apply:infra
./scripts/deploy apply:pgsql
./scripts/deploy apply:app
```

## Customization Guide

### Add a PostgreSQL User

Edit `templates/overrides/modules/pgsql.yml`:

```yaml
pg_users:
  - { name: myapp, password: 'secure_password', pgbouncer: true }
```

Then:
```bash
./scripts/deploy config:sync
./scripts/deploy apply:pgsql -t pg_user
```

### Change Grafana Password

Edit `.env`:
```bash
GRAFANA_ADMIN_PASSWORD=new_password
```

Then:
```bash
./scripts/deploy config:sync
./scripts/deploy apply:infra -t grafana_config
```

### Configure SSL/HTTPS

**Prerequisites:**
1. Point your domain DNS to your VPS IP
2. Ensure ports 80 and 443 are open

Edit `.env`:
```bash
SUPABASE_DOMAIN=bitsflaredb.bits.do
LETSENCRYPT_EMAIL=your@email.com
USE_LETSENCRYPT=true
```

**Setup SSL (automatic):**
```bash
./scripts/deploy ssl:setup
```

This will:
1. Update `pigsty.yml` with your domain and certbot configuration
2. Apply nginx configuration changes
3. Request Let's Encrypt certificate via Pigsty's built-in certbot
4. Update Supabase URLs to use HTTPS
5. Restart services

**Check certificate status:**
```bash
./scripts/deploy ssl:status
```

**Test renewal (dry-run):**
```bash
./scripts/deploy ssl:renew --dry-run
```

**Notes:**
- Certbot is pre-installed in Pigsty INFRA nodes
- Auto-renewal is configured via systemd timer
- Certificates are valid for 90 days
- `make cert` can also be used directly on the VPS

## Best Practices

1. **Never edit `base.yml`** - It's the official template
2. **Use overrides** for customizations
3. **Commit overrides to Git**
4. **Keep `.env` and `generated/` out of Git**
5. **Always backup before major changes**
6. **Test in development first**

## Version Control

**Tracked in Git:**
- `templates/base.yml`
- `templates/overrides/**/*.yml`
- `environments/*.env` (templates only)

**Ignored:**
- `.env`
- `generated/`
- `patches/credentials.yml`
- `*.backup.*`
