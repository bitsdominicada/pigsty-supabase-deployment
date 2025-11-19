# Get Started in 3 Steps

## Step 1: Generate Secure Configuration (2 minutes)

```bash
./scripts/generate-secrets
```

Answer the prompts:
- VPS IP address
- VPS root password
- Domain (optional)
- SMTP (optional)

**Important:** Save the displayed credentials in your password manager!

## Step 2: Deploy (15-25 minutes)

```bash
./scripts/deploy all
```

This will:
1. Prepare VPS (create user, SSH keys)
2. Download and configure Pigsty
3. Install PostgreSQL 17 + HA stack
4. Deploy Supabase containers
5. Setup monitoring

Grab a coffee while it runs!

## Step 3: Access Your Infrastructure

### Supabase Studio
```bash
open http://YOUR_VPS_IP:8000
```
Login: `supabase` / `pigsty` (change this immediately!)

### Grafana Dashboard
```bash
open http://YOUR_VPS_IP
```
Login: `admin` / `your_GRAFANA_ADMIN_PASSWORD`

### PostgreSQL
```bash
# Via pgbouncer (recommended)
psql postgres://supabase_admin:PASSWORD@YOUR_VPS_IP:5436/supa
```

## Verify Everything Works

```bash
./scripts/deploy verify
```

## Post-Deployment Checklist

- [ ] Change Supabase default password in Studio
- [ ] Save all credentials in password manager
- [ ] Configure firewall (optional but recommended)
- [ ] Setup domain and SSL if applicable
- [ ] Test Supabase features (Auth, Storage, etc.)

## Need Help?

- Quick questions: See [QUICKSTART.md](QUICKSTART.md)
- Full documentation: See [README.md](README.md)
- Migrating from v1: See [MIGRATION.md](MIGRATION.md)

## What's Running?

After deployment, you'll have:
- PostgreSQL 17 with Patroni (HA)
- Supabase (Auth, Storage, Realtime, Functions)
- Grafana monitoring with 26+ dashboards
- MinIO for S3-compatible storage
- Automated daily backups
- pgbouncer for connection pooling

All managed from your Mac!
