# Quick Start Guide

## Pre-requisitos

1. Mac con Homebrew instalado
2. VPS activo (Contabo o similar) con:
   - Ubuntu 22.04 o Rocky Linux 8/9
   - IP estática
   - Acceso root via SSH

## Instalación en 5 Minutos

### 1. Clonar Proyecto

```bash
git clone https://github.com/bitsdominicada/pigsty-supabase-deployment.git
cd pigsty-supabase-deployment
```

### 2. Configurar Credenciales

```bash
cp .env.example .env
nano .env  # o vi .env
```

**Mínimo requerido:**
```bash
VPS_HOST=YOUR_VPS_IP
VPS_ROOT_PASSWORD=your_root_password
POSTGRES_PASSWORD=change_this
GRAFANA_ADMIN_PASSWORD=change_this
```

### 3. Generar JWT Keys

```bash
./scripts/generate-jwt-keys.sh
```

Copiar las 3 keys generadas a `.env`:
- `JWT_SECRET`
- `ANON_KEY`
- `SERVICE_ROLE_KEY`

### 4. Ejecutar Deployment

```bash
# Preparar VPS (2-3 minutos)
./scripts/01-prepare-vps.sh

# Desplegar Pigsty + Supabase (15-20 minutos)
./scripts/02-deploy-pigsty.sh
```

### 5. Acceder

```bash
# Supabase Studio
open http://YOUR_VPS_IP:8000

# Grafana
open http://YOUR_VPS_IP
```

## Próximos Pasos

- [ ] Cambiar contraseñas default
- [ ] Configurar backups: `./scripts/setup-backup.sh`
- [ ] Configurar SSL: `./scripts/setup-ssl.sh`
- [ ] Health check: `./scripts/health-check.sh`

---

¿Problemas? Ver [README.md](../README.md) o abrir un issue.
