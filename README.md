# Pigsty Supabase Deployment

🚀 **Deployment automatizado de Pigsty con Supabase desde macOS a VPS remoto**

Este proyecto permite desplegar Supabase self-hosted con PostgreSQL 17 de alta disponibilidad usando Pigsty, completamente desde tu Mac hacia un VPS (Contabo u otro proveedor).

---

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Arquitectura](#-arquitectura)
- [Requisitos](#-requisitos)
- [Instalación Rápida](#-instalación-rápida)
- [Configuración Detallada](#-configuración-detallada)
- [Uso](#-uso)
- [Mantenimiento](#-mantenimiento)
- [Troubleshooting](#-troubleshooting)

---

## ✨ Características

### Stack Completo
- **PostgreSQL 17** con 423+ extensiones
- **Supabase** completo (Auth, Storage, Realtime, Functions, Edge)
- **Alta Disponibilidad** con Patroni
- **Monitoring** avanzado con Prometheus + Grafana (26 dashboards)
- **Backups** automáticos con pgBackRest + PITR
- **MinIO** para almacenamiento S3-compatible

### Ventajas
- ✅ Deployment remoto 100% automatizado
- ✅ Infrastructure as Code (IaC)
- ✅ Ahorro 90%+ vs Supabase Cloud
- ✅ Data sovereignty y compliance
- ✅ SSL/TLS con Let's Encrypt
- ✅ Proyecto reutilizable y versionado

---

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────┐
│  Tu Mac (Control Node)                          │
│  ├─ Ansible                                     │
│  ├─ Scripts de deployment                       │
│  └─ SSH Key Management                          │
└────────────┬────────────────────────────────────┘
             │ SSH
             ↓
┌─────────────────────────────────────────────────┐
│  VPS Contabo (Target Node)                      │
│                                                  │
│  ┌─────────────────────────────────────────┐   │
│  │ PIGSTY CORE                              │   │
│  │ ├─ PostgreSQL 17 (Patroni HA)           │   │
│  │ ├─ Pgbouncer (Connection Pooling)       │   │
│  │ ├─ HAProxy (Load Balancing)             │   │
│  │ ├─ pgBackRest (Backups + PITR)          │   │
│  │ └─ ETCD (Distributed Config)            │   │
│  └─────────────────────────────────────────┘   │
│                                                  │
│  ┌─────────────────────────────────────────┐   │
│  │ SUPABASE (Docker Compose)                │   │
│  │ ├─ Kong (API Gateway) :8000              │   │
│  │ ├─ GoTrue (Auth)                         │   │
│  │ ├─ PostgREST (REST API)                  │   │
│  │ ├─ Realtime (WebSockets)                 │   │
│  │ ├─ Storage (File uploads)                │   │
│  │ └─ Studio (Dashboard)                    │   │
│  └─────────────────────────────────────────┘   │
│                                                  │
│  ┌─────────────────────────────────────────┐   │
│  │ INFRA                                    │   │
│  │ ├─ Grafana :80 (Monitoring)              │   │
│  │ ├─ Prometheus (Metrics)                  │   │
│  │ ├─ MinIO :9000 (S3 Storage)              │   │
│  │ └─ Nginx (Reverse Proxy)                 │   │
│  └─────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

---

## 📦 Requisitos

### En tu Mac
- **macOS** 10.15+
- **Homebrew** instalado
- **GitHub CLI** (`gh`) - ya instalado ✓
- **SSH** client
- **Git**

### VPS (Contabo)
- **OS**: Ubuntu 22.04/24.04, Rocky Linux 8/9, o Debian 12
- **CPU**: Mínimo 2 cores (4+ recomendado)
- **RAM**: Mínimo 4GB (8GB+ recomendado)
- **Disk**: Mínimo 40GB SSD
- **IP**: IPv4 estática
- **Acceso**: Root via SSH con contraseña

---

## 🚀 Instalación Rápida

### 1. Clonar el Repositorio

```bash
cd ~/Projects
git clone https://github.com/bitsdominicada/pigsty-supabase-deployment.git
cd pigsty-supabase-deployment
```

### 2. Configurar Credenciales

```bash
# Copiar template de configuración
cp .env.example .env

# Editar con tus datos
vi .env
```

**Parámetros críticos a configurar:**
```bash
VPS_HOST=your.vps.ip.address
VPS_ROOT_PASSWORD=your_root_password

JWT_SECRET=your-super-secret-jwt-token-with-at-least-40-characters
POSTGRES_PASSWORD=your_strong_pg_password
GRAFANA_ADMIN_PASSWORD=your_grafana_password
```

### 3. Generar JWT Keys

```bash
./scripts/generate-jwt-keys.sh
```

Copia las keys generadas a tu archivo `.env`.

### 4. Preparar el VPS

```bash
./scripts/01-prepare-vps.sh
```

Este script:
- Crea usuario `deploy` (non-root)
- Configura SSH key authentication
- Instala dependencias base
- Genera inventario Ansible

### 5. Desplegar Pigsty + Supabase

```bash
./scripts/02-deploy-pigsty.sh
```

**Duración:** 15-25 minutos

---

## ⚙️ Configuración Detallada

### Estructura del Proyecto

```
pigsty-supabase-deployment/
├── .env                          # Configuración (NO commit!)
├── .env.example                  # Template de configuración
├── .gitignore                    # Archivos ignorados
├── README.md                     # Este archivo
│
├── scripts/                      # Scripts de automatización
│   ├── 01-prepare-vps.sh        # Preparación inicial del VPS
│   ├── 02-deploy-pigsty.sh      # Deployment principal
│   ├── generate-jwt-keys.sh     # Generador de JWT keys
│   ├── generate-pigsty-config.sh # Generador de config
│   ├── health-check.sh          # Verificación de salud
│   ├── setup-backup.sh          # Configurar backups
│   └── setup-ssl.sh             # Configurar SSL/TLS
│
├── config/                       # Archivos de configuración
│   ├── pigsty.yml               # (generado) Config Pigsty
│   └── supabase-env.yml         # (generado) Env Supabase
│
├── ansible/                      # Ansible files
│   ├── inventory/
│   │   └── hosts.ini            # (generado) Inventario
│   └── playbooks/               # Custom playbooks
│
└── docs/                         # Documentación adicional
```

### Variables de Entorno (.env)

Ver `.env.example` para todas las opciones disponibles.

**Categorías:**
- VPS Connection
- Supabase Configuration
- PostgreSQL Configuration
- Grafana/Monitoring
- MinIO (S3 Storage)
- SMTP (Email)
- Backup Configuration
- SSL/TLS Certificates

---

## 🎯 Uso

### Acceder a Supabase

```bash
# Supabase Studio
open http://YOUR_VPS_IP:8000

# Credenciales default
User: supabase
Pass: pigsty
```

### Acceder a Grafana

```bash
open http://YOUR_VPS_IP

User: admin
Pass: [tu GRAFANA_ADMIN_PASSWORD]
```

### Conectar a PostgreSQL

```bash
# Via pgbouncer (pooled)
psql postgres://supabase_admin:PASSWORD@YOUR_VPS_IP:5436/supa

# Directo a PostgreSQL
psql postgres://supabase_admin:PASSWORD@YOUR_VPS_IP:5432/supa

# Via SSH tunnel (más seguro)
ssh -i ~/.ssh/pigsty_deploy -L 5432:localhost:5432 deploy@YOUR_VPS_IP
psql postgres://supabase_admin:PASSWORD@localhost:5432/supa
```

### Health Check

```bash
./scripts/health-check.sh
```

Verifica:
- Conexión SSH
- PostgreSQL, Patroni, Pgbouncer
- Containers Docker de Supabase
- Endpoints HTTP
- Recursos del sistema

---

## 🔧 Mantenimiento

### Configurar Backups Automáticos

```bash
./scripts/setup-backup.sh
```

Crea:
- Script de backup en `/usr/local/bin/pigsty-backup.sh`
- Cron job diario (por defecto 01:00 AM)
- Logs en `/var/log/pigsty-backup.log`

### Configurar SSL/TLS

```bash
# Para Let's Encrypt (dominio real)
# 1. Configurar en .env:
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=your@email.com
SUPABASE_DOMAIN=supa.yourdomain.com

# 2. Ejecutar:
./scripts/setup-ssl.sh
```

### Backup Manual

```bash
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP
sudo -u postgres /pg/bin/pg-backup full
```

### Restaurar Backup

```bash
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP
sudo -u postgres pgbackrest --stanza=pg-meta restore
```

### Ver Logs

```bash
# Logs de PostgreSQL
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP "sudo tail -f /pg/log/postgres/*.csv"

# Logs de Supabase containers
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP "sudo docker compose -f ~/pigsty/app/supabase/docker-compose.yml logs -f"

# Logs de Patroni
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP "sudo journalctl -u patroni -f"
```

### Actualizar Supabase

```bash
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP
cd ~/pigsty
./app.yml -t app_pull  # Pull new images
./app.yml -t app_launch  # Restart containers
```

---

## 🐛 Troubleshooting

### SSH Connection Failed

```bash
# Verificar conectividad
ping YOUR_VPS_IP

# Verificar credenciales root
sshpass -p 'YOUR_ROOT_PASSWORD' ssh root@YOUR_VPS_IP

# Regenerar SSH key
rm ~/.ssh/pigsty_deploy*
./scripts/01-prepare-vps.sh
```

### Pigsty Installation Failed

```bash
# Conectar al VPS
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP

# Ver logs de instalación
cd ~/pigsty
cat ansible.log

# Reintentar instalación
./install.yml --tags=<failed_tag>
```

### Supabase Not Starting

```bash
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP

# Ver estado de containers
sudo docker ps -a

# Ver logs
sudo docker compose -f ~/pigsty/app/supabase/docker-compose.yml logs

# Reiniciar Supabase
cd ~/pigsty
./app.yml -t app_restart
```

### PostgreSQL Connection Issues

```bash
# Verificar que Patroni está running
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP "sudo systemctl status patroni"

# Ver estado del cluster
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP "sudo -u postgres patronictl -c /pg/bin/patroni.yml list"

# Verificar pgbouncer
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP "sudo systemctl status pgbouncer"
```

### Out of Memory

```bash
# Verificar uso de memoria
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP "free -h"

# Agregar swap
ssh -i ~/.ssh/pigsty_deploy deploy@YOUR_VPS_IP << 'SWAP'
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
SWAP
```

---

## 📚 Documentación Adicional

- [Pigsty Official Docs](https://pigsty.io/docs/)
- [Supabase Self-Hosting](https://pigsty.io/docs/app/supabase/)
- [PostgreSQL 17 Release Notes](https://www.postgresql.org/docs/17/release-17.html)
- [Patroni Documentation](https://patroni.readthedocs.io/)

---

## 🤝 Contribuir

Las contribuciones son bienvenidas! Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo licencia AGPLv3 (heredada de Pigsty).

---

## 🙏 Agradecimientos

- [Pigsty Project](https://github.com/pgsty/pigsty) por la increíble plataforma
- [Supabase](https://github.com/supabase/supabase) por el BaaS open-source
- [PostgreSQL](https://www.postgresql.org/) por el mejor RDBMS del mundo

---

## 📞 Soporte

¿Problemas? Abre un [Issue](https://github.com/bitsdominicada/pigsty-supabase-deployment/issues)

---

**Hecho con ❤️ para la comunidad PostgreSQL**
