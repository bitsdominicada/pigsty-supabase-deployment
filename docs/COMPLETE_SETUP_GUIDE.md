# Guía Completa de Configuración - Pigsty + Supabase + Backblaze B2

## 🎯 Overview

Esta guía muestra cómo hacer un deployment completo de Pigsty + Supabase con **Backblaze B2** como storage y **tu propio dominio**.

## 📋 Requisitos Previos

- ✅ VPS Ubuntu 22.04+ con al menos 2GB RAM
- ✅ Dominio (ejemplo: bits.do) con acceso a DNS
- ✅ Cuenta Backblaze B2 (10GB gratis)
- ✅ SSH access al VPS

## 🚀 Deployment Completo (3 Pasos)

### Paso 1: Configurar DNS

En tu proveedor DNS (Cloudflare, etc.), crea un registro A:

```
Tipo: A
Nombre: supa
Valor: <IP-de-tu-VPS>
TTL: Auto o 3600
```

**Resultado:** `supa.bits.do` → `194.163.149.70`

Verifica:
```bash
dig supa.bits.do +short
# Debe mostrar tu IP
```

### Paso 2: Crear Bucket Backblaze B2

1. **Login:** https://secure.backblaze.com/
2. **Crear Bucket:**
   - Click "Create a Bucket"
   - Name: `bits-supabase-storage`
   - Files: Public
   - Encryption: Disable
   - Object Lock: Disable

3. **Crear Application Key:**
   - Ve a: https://secure.backblaze.com/app_keys.htm
   - Click "Add a New Application Key"
   - Name: `supabase-storage`
   - Bucket: `bits-supabase-storage`
   - Permissions: Read and Write
   - **⚠️ GUARDA:** keyID y applicationKey

### Paso 3: Configurar y Deployar

```bash
# 1. Clonar repositorio
git clone https://github.com/tu-usuario/pigsty-supabase-deployment.git
cd pigsty-supabase-deployment

# 2. Copiar y configurar .env
cp .env.backblaze.example .env
nano .env
```

**Configurar estas variables en `.env`:**

```bash
# ============================================
# VPS CREDENTIALS
# ============================================
VPS_HOST=194.163.149.70
VPS_ROOT_PASSWORD=tu_password_root

# ============================================
# DOMAIN & SSL
# ============================================
SUPABASE_DOMAIN=supa.bits.do
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=admin@bits.do

# ============================================
# BACKBLAZE B2 STORAGE
# ============================================
S3_BUCKET=bits-supabase-storage
S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
S3_REGION=us-east-005
S3_ACCESS_KEY=<tu-keyID>
S3_SECRET_KEY=<tu-applicationKey>
S3_FORCE_PATH_STYLE=false
S3_PROTOCOL=https

# CRITICAL: Backblaze B2 compatibility
TUS_ALLOW_S3_TAGS=false

# ============================================
# PGBACKREST - BACKUPS TO B2
# ============================================
PGBACKREST_ENABLED=true
PGBACKREST_METHOD=s3
PGBACKREST_S3_BUCKET=bits-supabase-storage
PGBACKREST_S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
PGBACKREST_S3_REGION=us-east-005
PGBACKREST_S3_ACCESS_KEY=<tu-keyID>
PGBACKREST_S3_SECRET_KEY=<tu-applicationKey>
PGBACKREST_RETENTION_FULL=14
```

**Deployment:**

```bash
# Generar contraseñas seguras automáticamente
./scripts/generate-secrets

# Deploy completo (15-20 minutos)
./scripts/deploy all
```

**Esto automáticamente:**
1. ✅ Prepara el VPS
2. ✅ Instala Pigsty (PostgreSQL 17 HA)
3. ✅ Instala Docker + Supabase
4. ✅ Detecta Backblaze B2 y configura `TUS_ALLOW_S3_TAGS=false`
5. ✅ Configura SSL con Let's Encrypt
6. ✅ Configura pgBackRest para backups en B2

## ✅ Verificación

### 1. Verificar Servicios

```bash
./scripts/deploy verify
```

Deberías ver:
```
✅ PostgreSQL 17 running
✅ Supabase API responding
✅ Storage API healthy
✅ SSL certificate valid
✅ pgBackRest configured
```

### 2. Acceder a Supabase

```
URL: https://supa.bits.do
Usuario: (configurado en DASHBOARD_USERNAME)
Password: (configurado en DASHBOARD_PASSWORD)
```

### 3. Probar Storage

```bash
./scripts/deploy storage:test
```

Debería mostrar:
```
✅ File uploaded to Backblaze B2!
✅ File downloaded successfully
```

### 4. Verificar Backup

```bash
ssh root@<VPS_IP> 'sudo -iu postgres pgbackrest --stanza=pg-meta info'
```

Deberías ver backups en Backblaze B2.

## 🔧 Configuración Post-Deployment

### 1. Cambiar Contraseñas por Defecto

```bash
# En Supabase Studio
https://supa.bits.do

# Ir a: Settings → Dashboard → Change Password
```

### 2. Configurar OAuth Providers

En Supabase Studio:
- Settings → Authentication → Providers
- Configurar Google, GitHub, etc.
- **Redirect URL:** `https://supa.bits.do/auth/v1/callback`

### 3. Configurar SMTP (Email)

Edita `.env` local:
```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=tu@email.com
SMTP_PASSWORD=tu_app_password
SMTP_SENDER_NAME=Tu App
```

Aplica:
```bash
./scripts/deploy config:sync
./scripts/deploy apply:app
```

### 4. Crear Base de Datos

```sql
-- Desde Supabase Studio → SQL Editor
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Habilitar RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Política: usuarios solo ven sus datos
CREATE POLICY "Users can view own data"
  ON users FOR SELECT
  USING (auth.uid() = id);
```

### 5. Configurar Storage Buckets

```sql
-- Crear bucket para avatares
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true);

-- Política: usuarios pueden subir avatares
CREATE POLICY "Users can upload avatars"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'avatars');
```

## 🔍 Arquitectura Desplegada

```
┌──────────────────────────────────────────────────────┐
│ Internet                                             │
└────────────────┬─────────────────────────────────────┘
                 │
                 │ HTTPS (Let's Encrypt)
                 ▼
┌──────────────────────────────────────────────────────┐
│ supa.bits.do (Nginx)                                 │
│   ├─ Supabase Studio (Dashboard)                    │
│   ├─ Auth API                                        │
│   ├─ REST API (PostgREST)                            │
│   ├─ Storage API                                     │
│   └─ Realtime                                        │
└────────────────┬─────────────────────────────────────┘
                 │
┌────────────────┴─────────────────────────────────────┐
│ VPS (194.163.149.70)                                 │
├──────────────────────────────────────────────────────┤
│                                                      │
│ PostgreSQL 17 (High Availability)                    │
│   ├─ pgBouncer (Connection Pooler)                  │
│   ├─ HAProxy (Load Balancer)                        │
│   └─ Extensions: pgvector, timescaledb, pgsodium    │
│                                                      │
│ Monitoring (Internal)                                │
│   ├─ Grafana → g.pigsty:3000                        │
│   ├─ Prometheus → p.pigsty:9090                     │
│   └─ AlertManager → a.pigsty:9093                   │
│                                                      │
└──────────────────────────────────────────────────────┘
                 │
                 │ Storage & Backups
                 ▼
┌──────────────────────────────────────────────────────┐
│ Backblaze B2 (bits-supabase-storage)                │
│   ├─ stub/ → Supabase Storage (user files)          │
│   └─ pgbackrest/ → PostgreSQL Backups               │
└──────────────────────────────────────────────────────┘
```

## 📊 Características Clave

### Storage (100% Backblaze B2)
- ✅ **TUS_ALLOW_S3_TAGS=false** configurado automáticamente
- ✅ Sin MinIO local necesario
- ✅ $0.005/GB/mes
- ✅ Escalabilidad ilimitada

### PostgreSQL (High Availability)
- ✅ PostgreSQL 17 con 26+ extensiones
- ✅ Connection pooling (pgBouncer)
- ✅ Load balancing (HAProxy)
- ✅ Streaming replication ready

### Backups (pgBackRest)
- ✅ Backups completos diarios
- ✅ Backups incrementales
- ✅ WAL archiving continuo
- ✅ Point-in-Time Recovery (PITR)
- ✅ Encriptación AES-256-CBC
- ✅ Retención de 14 días

### Monitoring (Grafana)
- ✅ Dashboard PostgreSQL
- ✅ Dashboard Sistema (CPU, RAM, Disk)
- ✅ Dashboard Supabase
- ✅ Alertas configurables

### SSL/TLS
- ✅ Let's Encrypt automático
- ✅ Renovación automática
- ✅ HTTPS forzado

## 🛠️ Comandos Útiles

### Deployment
```bash
./scripts/deploy all              # Deployment completo
./scripts/deploy prepare          # Solo preparar VPS
./scripts/deploy install          # Solo instalar stack
./scripts/deploy verify           # Health check
```

### Configuración
```bash
./scripts/deploy config:sync      # Subir config local → VPS
./scripts/deploy config:pull      # Descargar config VPS → local
./scripts/deploy config:diff      # Ver diferencias
```

### Storage
```bash
./scripts/deploy storage:b2       # Configurar Backblaze B2
./scripts/deploy storage:test     # Probar uploads/downloads
```

### SSL
```bash
./scripts/deploy ssl:setup        # Configurar HTTPS
./scripts/deploy ssl:status       # Ver estado certificado
./scripts/deploy ssl:renew        # Renovar certificado
```

### Aplicar Cambios
```bash
./scripts/deploy apply            # Aplicar todos los cambios
./scripts/deploy apply:app        # Solo Supabase
./scripts/deploy apply:pgsql      # Solo PostgreSQL
./scripts/deploy apply:infra      # Solo infraestructura
```

## 📱 Acceso a Servicios

### Públicos (Internet)
```
Supabase Studio: https://supa.bits.do
API Endpoint:    https://supa.bits.do
```

### Internos (SSH Tunnel)
```bash
# Grafana
ssh -L 3000:localhost:3000 deploy@<VPS_IP>
# Abrir: http://localhost:3000

# Prometheus
ssh -L 9090:localhost:9090 deploy@<VPS_IP>
# Abrir: http://localhost:9090

# PostgreSQL directo
ssh -L 5432:localhost:5432 deploy@<VPS_IP>
# Conectar: postgresql://postgres@localhost:5432/postgres
```

## 💰 Costos Estimados

### VPS
```
Contabo VPS S SSD: $6.99/mes
  - 4 vCPU
  - 8 GB RAM
  - 200 GB NVMe
```

### Backblaze B2 (Ejemplo: 50GB datos)
```
Almacenamiento:    50GB × $0.005 = $0.25/mes
Backups PostgreSQL: 30GB × $0.005 = $0.15/mes
Total B2:          $0.40/mes
```

### Total Mensual
```
VPS:         $6.99
Backblaze B2: $0.40
──────────────────
TOTAL:       $7.39/mes
```

**Comparación con Supabase Cloud:**
- Supabase Pro: $25/mes
- **Ahorro:** $17.61/mes (70% más barato)

## 🔐 Seguridad

### Contraseñas Generadas Automáticamente
```bash
./scripts/generate-secrets
```

Genera:
- PostgreSQL password (32 caracteres)
- Grafana admin password
- MinIO passwords (si aplica)
- JWT secrets
- Supabase dashboard password
- pgBackRest encryption key

### Firewall
```bash
# Solo permitir puertos necesarios
ufw allow 22/tcp   # SSH
ufw allow 80/tcp   # HTTP (redirect)
ufw allow 443/tcp  # HTTPS
ufw enable
```

### SSL/TLS
- Certificados Let's Encrypt
- Renovación automática cada 60 días
- HTTPS forzado para API pública

## 📚 Documentación Adicional

- [Backblaze B2 Setup](./BACKBLAZE_B2_SETUP.md)
- [Storage Architecture](./STORAGE_ARCHITECTURE.md)
- [Domain Configuration](./DOMAIN_CONFIGURATION.md)
- [pgBackRest Backup](./PGBACKREST_BACKUP.md)
- [Troubleshooting](../TROUBLESHOOTING.md)

## ❓ FAQ

### ¿Puedo usar MinIO en lugar de Backblaze B2?

Sí, simplemente deja las configuraciones por defecto:
```bash
S3_ENDPOINT=https://sss.pigsty:9000
# No configurar TUS_ALLOW_S3_TAGS
```

### ¿Funciona con Cloudflare R2?

Sí, Cloudflare R2 también necesita `TUS_ALLOW_S3_TAGS=false`:
```bash
S3_ENDPOINT=https://<account>.r2.cloudflarestorage.com
TUS_ALLOW_S3_TAGS=false
```

### ¿Puedo cambiar el dominio después?

Sí:
```bash
# Editar .env
SUPABASE_DOMAIN=nuevo.dominio.com

# Aplicar
./scripts/deploy config:sync
./scripts/deploy ssl:setup
```

### ¿Cómo hacer backup manual?

```bash
ssh root@<VPS_IP>
sudo -iu postgres pgbackrest --stanza=pg-meta backup
```

### ¿Cómo restaurar desde backup?

Ver guía completa: [PGBACKREST_BACKUP.md](./PGBACKREST_BACKUP.md)

## 🎯 Próximos Pasos

Después del deployment:

1. **Cambiar contraseñas por defecto**
2. **Configurar OAuth providers**
3. **Crear tu primera tabla**
4. **Configurar RLS policies**
5. **Crear storage buckets**
6. **Configurar SMTP para emails**
7. **Monitorear en Grafana**

---

## 🎉 ¡Listo!

Ahora tienes:
- ✅ PostgreSQL 17 HA
- ✅ Supabase completo con tu dominio
- ✅ Storage en Backblaze B2
- ✅ Backups automáticos
- ✅ SSL/TLS automático
- ✅ Monitoring con Grafana
- ✅ Todo por ~$7/mes

**¿Preguntas?** Abre un issue en GitHub o consulta la documentación.
