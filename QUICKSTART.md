# Quick Start (5 minutes)

## Option A: Auto-Generate Configuration (Recommended)

```bash
# Interactive configuration with auto-generated secure passwords
./scripts/generate-secrets
```

This will:
- Generate all secure passwords (32+ characters)
- Create JWT tokens automatically
- Ask for VPS details
- Optionally configure domain & SSL
- Create `.env` file ready to use

## Option B: Manual Configuration

```bash
cp .env.example .env
vi .env
```

Generate passwords:
```bash
# Strong passwords (32 characters)
openssl rand -base64 32

# JWT Secret
openssl rand -base64 32
```

Fill in `.env`:
```bash
VPS_HOST=1.2.3.4
VPS_ROOT_PASSWORD=your_root_password
DEPLOY_USER_PASSWORD=$(openssl rand -base64 32)
POSTGRES_PASSWORD=$(openssl rand -base64 32)
PG_ADMIN_PASSWORD=$(openssl rand -base64 32)
GRAFANA_ADMIN_PASSWORD=$(openssl rand -base64 32)
MINIO_ROOT_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
```

---

## Deploy

```bash
./scripts/deploy all
```

Wait 15-25 minutes.

---

## Access

```bash
# Supabase Studio
open http://YOUR_VPS_IP:8000
# Login: supabase / pigsty (CHANGE THIS!)

# Grafana
open http://YOUR_VPS_IP
# Login: admin / your_GRAFANA_ADMIN_PASSWORD
```

---

## Verify

```bash
./scripts/deploy verify
```

---

## Done!

Next steps:
- Change Supabase default password in Studio
- Save all credentials in a password manager
- Read full docs: [README.md](README.md)
