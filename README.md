# Pigsty Supabase Deployment

Automated deployment of **Supabase** with **PostgreSQL 17 HA** using **Pigsty**, from macOS to VPS.

---

> 🚀 **[¿Primera vez? Lee la GUÍA RÁPIDA →](QUICK_START.md)**  
> 3 comandos, 20 minutos, sin editar archivos manualmente.

---

## ⚠️ Principios de Configuración (IMPORTANTE)

Este proyecto sigue las mejores prácticas de **Infraestructura como Código (IaC)**:

### 1. **NO editar archivos en el VPS manualmente**
   - ❌ NO editar `/pg/data/pg_hba.conf` directamente
   - ❌ NO editar `/opt/supabase/.env` directamente
   - ✅ Toda configuración debe estar en `pigsty.yml`
   - ✅ Aplicar cambios vía playbooks de Ansible

### 2. **Seguir la secuencia oficial de Pigsty**
   ```bash
   ./configure -c app/supa -i <IP> -n  # Generar configuración
   ./install.yml                        # PostgreSQL, MinIO, infraestructura
   ./docker.yml                         # Docker y Docker Compose
   ./app.yml                            # Supabase containers
   ```

### 3. **pg_hba.conf se gestiona vía pigsty.yml**
   Las reglas de acceso PostgreSQL están en `pg_hba_rules`:
   ```yaml
   pg_hba_rules:
     - { user: all, db: postgres, addr: intra, auth: pwd, title: 'allow supabase access from intranet' }
     - { user: all, db: postgres, addr: 172.17.0.0/16, auth: pwd, title: 'allow access from local docker network' }
   ```
   Estas reglas son **críticas** para que los contenedores Docker de Supabase puedan conectarse a PostgreSQL.

### 4. **Confiar en la plantilla oficial**
   La plantilla `conf/supabase.yml` de Pigsty ya está optimizada y probada. No intentes "mejorarla" sin entender completamente las implicaciones.

---

## Features

- **PostgreSQL 17** with 423+ extensions
- **Supabase** full stack (Auth, Storage, Realtime, Functions)
- **High Availability** with Patroni
- **Monitoring** with Prometheus + Grafana (26 dashboards)
- **Backups** with pgBackRest + PITR to Backblaze B2
- **Storage**: MinIO (local S3) + Backblaze B2 (cloud backups)
- **100% automated** from your Mac
- **Point-in-Time Recovery** with automated daily backups to cloud

---

## Architecture

```
┌─────────────────────────────────┐
│  Your Mac (Control)             │
│  ├─ ./scripts/deploy            │
│  └─ SSH orchestration           │
└──────────────┬──────────────────┘
               │ SSH
               ↓
┌─────────────────────────────────┐
│  VPS (Target)                    │
│                                  │
│  ┌────────────────────────────┐ │
│  │ Pigsty (Official Template) │ │
│  │ ├─ PostgreSQL 17 + Patroni │ │
│  │ ├─ Pgbouncer + HAProxy     │ │
│  │ ├─ pgBackRest + ETCD       │ │
│  │ └─ Grafana + Prometheus    │ │
│  └────────────────────────────┘ │
│                                  │
│  ┌────────────────────────────┐ │
│  │ Supabase (Docker Compose)  │ │
│  │ ├─ Kong (API Gateway)      │ │
│  │ ├─ Auth + Storage          │ │
│  │ ├─ Realtime + REST API     │ │
│  │ └─ Studio (Dashboard)      │ │
│  └────────────────────────────┘ │
└─────────────────────────────────┘
```

---

## Quick Start

### 1. Clone & Configure

```bash
git clone https://github.com/bitsdominicada/pigsty-supabase-deployment.git
cd pigsty-supabase-deployment

# Auto-generate secure configuration (recommended)
./scripts/generate-secrets

# OR manually configure
cp .env.example .env
vi .env  # Set VPS_HOST, passwords, JWT_SECRET
```

**For HTTPS (optional but recommended):**
```bash
# Add to .env before deployment
SUPABASE_DOMAIN=your-domain.com
LETSENCRYPT_EMAIL=your@email.com
USE_LETSENCRYPT=true
```

### 2. One-Command Deployment

```bash
# Full deployment with automatic HTTPS (if configured)
./scripts/deploy all
```

**What happens automatically:**
1. ✅ Prepares VPS (user, SSH, firewall)
2. ✅ Configures Pigsty with official template
3. ✅ Installs PostgreSQL 17 + HA stack
4. ✅ Installs Docker + Supabase
5. ✅ **Sets up HTTPS** (if domain configured in .env)
6. ✅ Verifies all services

**Duration:** 15-25 minutes total

**Alternative (step by step):**
```bash
./scripts/deploy prepare   # VPS setup
./scripts/deploy config    # Generate configs
./scripts/deploy install   # Install stack
./scripts/deploy ssl:setup # HTTPS (if not auto-configured)
./scripts/deploy verify    # Health check
```

### 3. Access

```bash
# Supabase Studio
open http://YOUR_VPS_IP:8000

# Grafana
open http://YOUR_VPS_IP
```

---

## Prerequisites

### On Mac
- macOS 10.15+
- Homebrew
- SSH client

### VPS Requirements
- Ubuntu 22.04/24.04, Rocky 8/9, or Debian 12
- 4GB+ RAM (8GB recommended)
- 2+ CPU cores (4+ recommended)
- 40GB+ SSD
- Static IPv4
- Root SSH access

---

## Configuration

### Auto-Generate (Easiest)

```bash
./scripts/generate-secrets
```

This interactive script will:
- Generate all secure passwords (32+ characters)
- Create JWT tokens automatically
- Ask for your VPS IP and credentials
- Optionally configure domain & SSL
- Optionally configure SMTP
- Create `.env` file ready to deploy

### Manual Configuration

If you prefer manual setup:

```bash
cp .env.example .env
vi .env
```

**Required variables:**
```bash
VPS_HOST=1.2.3.4
VPS_ROOT_PASSWORD=your_password
DEPLOY_USER_PASSWORD=$(openssl rand -base64 32)
POSTGRES_PASSWORD=$(openssl rand -base64 32)
PG_ADMIN_PASSWORD=$(openssl rand -base64 32)
GRAFANA_ADMIN_PASSWORD=$(openssl rand -base64 32)
MINIO_ROOT_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
```

### Optional Variables

```bash
# Domain & SSL
SUPABASE_DOMAIN=supa.example.com
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=you@example.com

# SMTP (for email features)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your@email.com
SMTP_PASSWORD=app_password
```

---

## Project Structure

```
pigsty-supabase-deployment/
├── scripts/
│   ├── deploy              # Main orchestrator
│   ├── generate-secrets    # Auto-generate secure config
│   ├── utils.sh            # Shared utilities
│   └── modules/
│       ├── 01-prepare.sh   # VPS setup
│       ├── 02-configure.sh # Pigsty config (uses official template)
│       ├── 03-install.sh   # Stack installation
│       └── 04-verify.sh    # Health checks
├── ansible/
│   └── inventory/          # Generated inventory
├── .env.example            # Configuration template
├── .gitignore
└── README.md
```

---

## Usage

### Commands

```bash
# Generate secure configuration (do this first!)
./scripts/generate-secrets

# Full deployment
./scripts/deploy all

# Individual steps
./scripts/deploy prepare    # Setup VPS
./scripts/deploy config     # Configure Pigsty
./scripts/deploy install    # Install stack
./scripts/deploy verify     # Health check

# Help
./scripts/deploy help
```

### Access Points

| Service | URL | Default Credentials |
|---------|-----|---------------------|
| Supabase Studio | `http://VPS_IP:8000` | From `.env`: `DASHBOARD_USERNAME` / `DASHBOARD_PASSWORD` |
| Grafana | `http://VPS_IP` | `admin` / `your_GRAFANA_PASSWORD` |
| PostgreSQL | `VPS_IP:5436` | `supabase_admin` / `your_POSTGRES_PASSWORD` |
| MinIO (if used) | `http://VPS_IP:9000` | `minioadmin` / `your_MINIO_PASSWORD` |

> **💾 Storage Architecture**: Uses **MinIO** (local) for Supabase Storage and **Backblaze B2** (cloud) for PostgreSQL backups. See [Storage Architecture](docs/STORAGE_ARCHITECTURE.md) for details.  
> **📦 Backups**: Automated daily PostgreSQL backups to Backblaze B2 with Point-in-Time Recovery. See [pgBackRest Guide](docs/PGBACKREST_BACKUP.md) for backup configuration.

---

## Maintenance

### Backups

Backups run automatically at 1:00 AM daily via pgBackRest.

```bash
# Manual backup
ssh -i ~/.ssh/pigsty_deploy deploy@VPS_IP
sudo -u postgres /pg/bin/pg-backup full

# Restore
sudo -u postgres pgbackrest --stanza=pg-meta restore
```

### SSL/TLS with Let's Encrypt

**Prerequisites:**
1. Point your domain DNS to VPS IP
2. Open ports 80 and 443 on VPS

**Configure domain in .env BEFORE deployment:**
```bash
SUPABASE_DOMAIN=bitsflaredb.bits.do
LETSENCRYPT_EMAIL=your@email.com
USE_LETSENCRYPT=true
```

**Setup SSL:**

✅ **Automatic** (recommended): If configured in .env, SSL is set up automatically during `./scripts/deploy all`

🔧 **Manual** (if you forgot to configure before): 
```bash
# Add domain to .env, then run:
./scripts/deploy ssl:setup
```

**What happens internally:**

1. **Sync Configuration**
   - Updates `pigsty.yml` with domain in `infra_portal.supa`
   - Configures HTTPS URLs in `apps.supabase.conf`:
     ```yaml
     apps:
       supabase:
         conf:
           SITE_URL: https://bitsflaredb.bits.do
           API_EXTERNAL_URL: https://bitsflaredb.bits.do
           SUPABASE_PUBLIC_URL: https://bitsflaredb.bits.do
     ```

2. **Apply Nginx Configuration**
   - Runs `./infra.yml -t nginx_config,nginx_restart`
   - Creates `/etc/nginx/conf.d/supa.conf` with:
     ```nginx
     server {
         server_name  bitsflaredb.bits.do;
         listen       80;
         listen       443 ssl;
         location ^~ /.well-known/acme-challenge/ {
             root /www/acme;  # For Let's Encrypt validation
         }
     }
     ```

3. **Request Let's Encrypt Certificate**
   - Uses certbot with webroot method:
     ```bash
     certbot certonly --webroot \
       --webroot-path /www/acme \
       -d bitsflaredb.bits.do
     ```
   - Certificates stored in `/etc/letsencrypt/live/bitsflaredb.bits.do/`

4. **Configure Nginx with SSL Certificates**
   - Updates nginx to use Let's Encrypt certs:
     ```nginx
     ssl_certificate     /etc/letsencrypt/live/bitsflaredb.bits.do/fullchain.pem;
     ssl_certificate_key /etc/letsencrypt/live/bitsflaredb.bits.do/privkey.pem;
     ```
   - Reloads nginx

5. **Update Supabase Containers**
   - Updates `/opt/supabase/.env` with HTTPS URLs
   - Restarts all Supabase containers
   - Containers now use HTTPS endpoints

**Check certificate:**
```bash
./scripts/deploy ssl:status
```

**Test renewal:**
```bash
./scripts/deploy ssl:renew --dry-run
```

**Important Notes:**
- ✅ Certbot pre-installed in Pigsty
- ✅ Auto-renewal via systemd timer (`certbot.timer`)
- ✅ 90-day validity, auto-renews at 60 days
- ✅ Configuration in pigsty.yml survives redeployments
- ⚠️ Don't manually edit `/etc/nginx/conf.d/supa.conf` - regenerate via `./infra.yml`

### Logs

```bash
ssh -i ~/.ssh/pigsty_deploy deploy@VPS_IP

# PostgreSQL
sudo tail -f /pg/log/postgres/*.csv

# Supabase
sudo docker compose -f ~/pigsty/app/supabase/docker-compose.yml logs -f

# Patroni
sudo journalctl -u patroni -f
```

### Updates

```bash
# Update Supabase containers
ssh -i ~/.ssh/pigsty_deploy deploy@VPS_IP
cd ~/pigsty
./app.yml -t app_pull,app_launch
```

---

## Troubleshooting

### SSH Connection Failed

```bash
# Test connectivity
ping YOUR_VPS_IP

# Verify root access
sshpass -p 'YOUR_PASSWORD' ssh root@YOUR_VPS_IP

# Regenerate SSH keys
rm ~/.ssh/pigsty_deploy*
./scripts/deploy prepare
```

### Services Not Starting

```bash
# Check status
./scripts/deploy verify

# View logs
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP
sudo docker ps -a
sudo systemctl status patroni
```

### PostgreSQL Issues

```bash
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP

# Check Patroni cluster
sudo -u postgres patronictl -c /pg/bin/patroni.yml list

# Check pgbouncer
sudo systemctl status pgbouncer
```

---

## Design Principles

This project follows **best practices**:

1. **Official Template First**: Uses Pigsty's official `app/supa` template
2. **Minimal Patching**: Only overrides necessary values
3. **Clean Separation**: Modular scripts with single responsibility
4. **Idempotent**: Safe to run multiple times
5. **Production Ready**: HA, monitoring, backups included

---

## Comparison: This vs Manual

| Aspect | Manual Deployment | This Project |
|--------|------------------|--------------|
| Setup Time | 2-3 hours | 20 minutes |
| SSH Sessions | Multiple | Zero (automated) |
| Configuration | Manual editing | Template + .env |
| Reproducibility | Low | High |
| Multiple VPS | Tedious | Simple |
| Updates | Manual tracking | Version controlled |

---

## Advanced: Tailscale Integration

For enhanced security with zero-trust networking:

```bash
# Install Tailscale on Mac
brew install tailscale

# Connect VPS to Tailscale
ssh root@VPS_IP
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Update .env with Tailscale IP
VPS_HOST=100.x.x.x  # Tailscale IP
```

Benefits:
- Encrypted P2P connection
- No exposed SSH port
- Better for multiple VPS management

---

## FAQ

**Q: Can I deploy to multiple VPS?**  
A: Yes, just change `VPS_HOST` in `.env` and run `./scripts/deploy all`

**Q: How do I change Supabase default password?**  
A: Access Studio at port 8000, go to Settings → Database → Change password

**Q: Is this production-ready?**  
A: Yes, includes HA, monitoring, backups. Add SSL and firewall for internet-facing deployments.

**Q: How much does this save vs Supabase Cloud?**  
A: 90%+ savings. Example: $4GB VPS (~$10/month) vs Supabase Pro ($25/month)

---

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -m 'Add improvement'`)
4. Push to branch (`git push origin feature/improvement`)
5. Open Pull Request

---

## 📚 Lecciones Aprendidas

### Problema: Contenedores Supabase no se conectaban a PostgreSQL
**Síntoma**: `no pg_hba.conf entry for host "194.163.149.70"`

**Causa raíz**: 
- Los contenedores Docker se conectan vía HAProxy/pgbouncer, que preserva la IP del host
- Faltaban reglas `pg_hba.conf` para permitir conexión desde la IP del VPS

**Solución correcta**: 
Las reglas ya están en la plantilla oficial de Pigsty:
```yaml
pg_hba_rules:
  - { user: all, db: postgres, addr: intra, auth: pwd }
  - { user: all, db: postgres, addr: 172.17.0.0/16, auth: pwd }
```

**❌ NO hacer**: Editar `/pg/data/pg_hba.conf` manualmente  
**✅ Hacer**: Asegurar que `pigsty.yml` tenga las reglas y ejecutar `./install.yml`

---

### Problema: Secuencia de instalación incorrecta
**Error**: Instalé Docker manualmente antes de ejecutar `./docker.yml`

**Consecuencia**: Configuración inconsistente, contenedores fantasma

**Secuencia correcta** (documentada en https://pigsty.io/docs/app/supabase/):
```bash
1. ./configure -c app/supa -i <IP> -n
2. ./install.yml    # PostgreSQL, MinIO, infraestructura
3. ./docker.yml     # Docker (NO instalarlo manualmente)
4. ./app.yml        # Supabase
```

---

### Problema: Configuración no se aplicaba
**Síntoma**: Cambios en `.env` no tenían efecto

**Causa raíz**: 
- `app.yml` sobrescribe `/opt/supabase/.env` desde `apps.supabase.conf` en `pigsty.yml`
- Editar `.env` directamente es temporal

**Solución**:
```yaml
# En pigsty.yml
apps:
  supabase:
    conf:
      POSTGRES_HOST: 194.163.149.70
      POSTGRES_PORT: 5436
      # ... otros valores
```

Luego ejecutar: `./app.yml -t app_config,app_launch`

---

### Lección más importante

> **La plantilla oficial de Pigsty (`conf/supabase.yml`) ya tiene TODO configurado correctamente.**
> 
> No intentes "mejorar" o "simplificar" sin leer primero la documentación oficial.  
> Seguir la guía al pie de la letra es MÁS RÁPIDO que improvisar.

**Documentación oficial**: https://pigsty.io/docs/app/supabase/

---

## License

AGPLv3 (inherited from Pigsty)

---

## Credits

- [Pigsty](https://github.com/pgsty/pigsty) - PostgreSQL platform
- [Supabase](https://github.com/supabase/supabase) - BaaS framework
- [PostgreSQL](https://www.postgresql.org/) - Database

---

## Support

Issues: [GitHub Issues](https://github.com/bitsdominicada/pigsty-supabase-deployment/issues)

Documentation: [Pigsty Docs](https://pigsty.io/docs/app/supabase/)

---

**Made with ❤️ for the PostgreSQL community**
