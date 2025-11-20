# ✅ Checklist - Instalación Limpia desde Cero

## 📋 Pre-requisitos

### 1. VPS Limpio
- [ ] Ubuntu 22.04 o 24.04 LTS instalado
- [ ] Al menos 2GB RAM, 2 vCPU
- [ ] 50GB+ espacio en disco
- [ ] IP pública asignada: `194.163.149.70`

### 2. DNS Configurado
- [ ] Registro A creado: `bitsflaredb.bits.do` → `194.163.149.70`
- [ ] Propagación verificada:
  ```bash
  dig bitsflaredb.bits.do +short
  # Debe mostrar: 194.163.149.70
  ```

### 3. Backblaze B2
- [ ] Cuenta creada (https://www.backblaze.com/b2/sign-up.html)
- [ ] Bucket creado: `bits-supabase-storage`
- [ ] Application Key generada:
  - keyID: `0054f413fc50d980000000005`
  - applicationKey: `K005QH3QznmevY7wUCOU7r5NFmv9Q2U`
  - Region: `us-east-005`

### 4. Acceso SSH
- [ ] Password root conocido o acceso por SSH key
- [ ] Puerto 22 abierto
- [ ] Firewall permite SSH

---

## 🚀 Instalación (Paso a Paso)

### Paso 1: Preparar Configuración Local

```bash
# 1. Ir al proyecto
cd ~/Projects/pigsty-supabase-deployment

# 2. Verificar que estés en la rama correcta
git status

# 3. Copiar configuración de ejemplo
cp .env.backblaze.example .env

# 4. Editar .env
nano .env
```

**Variables críticas a configurar:**

```bash
# VPS
VPS_HOST=194.163.149.70
VPS_ROOT_PASSWORD=tu_password_root

# Dominio
SUPABASE_DOMAIN=bitsflaredb.bits.do
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=admin@bits.do

# Backblaze B2
S3_BUCKET=bits-supabase-storage
S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
S3_REGION=us-east-005
S3_ACCESS_KEY=0054f413fc50d980000000005
S3_SECRET_KEY=K005QH3QznmevY7wUCOU7r5NFmv9Q2U
S3_FORCE_PATH_STYLE=false
S3_PROTOCOL=https
TUS_ALLOW_S3_TAGS=false

# pgBackRest (mismo bucket)
PGBACKREST_ENABLED=true
PGBACKREST_METHOD=s3
PGBACKREST_S3_BUCKET=bits-supabase-storage
PGBACKREST_S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
PGBACKREST_S3_REGION=us-east-005
PGBACKREST_S3_ACCESS_KEY=0054f413fc50d980000000005
PGBACKREST_S3_SECRET_KEY=K005QH3QznmevY7wUCOU7r5NFmv9Q2U
PGBACKREST_RETENTION_FULL=14
```

### Paso 2: Generar Contraseñas Seguras

```bash
# Generar todas las contraseñas automáticamente
./scripts/generate-secrets

# Esto genera:
# - POSTGRES_PASSWORD
# - GRAFANA_ADMIN_PASSWORD
# - JWT_SECRET, ANON_KEY, SERVICE_ROLE_KEY
# - PGBACKREST_CIPHER_PASS
# Y actualiza tu .env
```

Verificar:
```bash
cat .env | grep -E "PASSWORD|SECRET|KEY" | head -10
```

### Paso 3: Deployment Completo

```bash
# Un solo comando (15-20 minutos)
./scripts/deploy all
```

**Esto ejecutará automáticamente:**
1. ✅ `prepare` - Preparar VPS (usuario, SSH, dependencias)
2. ✅ `config` - Configurar Pigsty
3. ✅ `install` - Instalar stack (Pigsty + Docker + Supabase)
4. ✅ **Detectar Backblaze B2 y configurar TUS_ALLOW_S3_TAGS=false**
5. ✅ `ssl:setup` - Configurar Let's Encrypt

**Salida esperada al final:**
```
✅ Deployment completed successfully!

Deployment Summary

✓ PostgreSQL 17 running on 194.163.149.70:5432
✓ pgBouncer connection pooler on 194.163.149.70:6432
✓ HAProxy load balancer on 194.163.149.70:5436
✓ Grafana dashboard at http://194.163.149.70:3000
✓ Supabase Studio at http://194.163.149.70:8000

✓ HTTPS Enabled: https://bitsflaredb.bits.do
```

---

## ✅ Verificación Post-Instalación

### 1. Health Check Completo

```bash
./scripts/deploy verify
```

**Salida esperada:**
```
✅ PostgreSQL 17 running
✅ Supabase API responding
✅ Storage API healthy
✅ SSL certificate valid
✅ pgBackRest configured
```

### 2. Verificar Backblaze B2 Storage

```bash
./scripts/deploy storage:test
```

**Salida esperada:**
```
✅ File uploaded to Backblaze B2!
✅ File downloaded successfully
```

### 3. Verificar SSL/HTTPS

```bash
# Desde tu navegador
https://bitsflaredb.bits.do

# Desde terminal
curl -I https://bitsflaredb.bits.do
```

**Debe mostrar:**
```
HTTP/2 200
```

### 4. Verificar pgBackRest

```bash
ssh root@194.163.149.70
sudo -iu postgres pgbackrest --stanza=pg-meta info
```

**Debe mostrar:**
```
stanza: pg-meta
    status: ok
    cipher: aes-256-cbc
```

### 5. Verificar TUS_ALLOW_S3_TAGS

```bash
ssh root@194.163.149.70
cd /opt/supabase
docker compose exec storage env | grep TUS_ALLOW_S3_TAGS
```

**Debe mostrar:**
```
TUS_ALLOW_S3_TAGS=false
```

---

## 🔍 Verificación de Servicios

### Supabase Studio

```
URL: https://bitsflaredb.bits.do
Usuario: (ver DASHBOARD_USERNAME en .env)
Password: (ver DASHBOARD_PASSWORD en .env)
```

**Verificar:**
- [ ] Login funciona
- [ ] Dashboard carga correctamente
- [ ] Puedes ver Database, Auth, Storage

### PostgreSQL

```bash
# Conectar desde local (a través de SSH tunnel)
ssh -L 5432:localhost:5432 root@194.163.149.70

# En otra terminal
psql postgresql://postgres:<PASSWORD>@localhost:5432/postgres
```

**Verificar:**
- [ ] Conexión exitosa
- [ ] Listar bases de datos: `\l`
- [ ] Ver extensiones: `SELECT * FROM pg_available_extensions;`

### Storage (Backblaze B2)

```bash
# Test manual
ssh root@194.163.149.70
cd /opt/supabase

# Crear bucket de prueba
curl -X POST http://127.0.0.1:8000/storage/v1/bucket \
  -H "Authorization: Bearer $SERVICE_ROLE_KEY" \
  -H "Content-Type: application/json" \
  -d '{"id":"test","name":"test","public":true}'

# Upload archivo
echo "Test" > /tmp/test.txt
curl -X POST http://127.0.0.1:8000/storage/v1/object/test/test.txt \
  -H "Authorization: Bearer $SERVICE_ROLE_KEY" \
  -F "file=@/tmp/test.txt"
```

**Debe responder:**
```json
{"Key":"test/test.txt","Id":"..."}
```

### Grafana (Monitoring)

```bash
# SSH tunnel
ssh -L 3000:localhost:3000 root@194.163.149.70

# Abrir navegador
http://localhost:3000
```

**Credenciales:**
- Usuario: `admin`
- Password: (ver GRAFANA_ADMIN_PASSWORD en .env)

**Verificar:**
- [ ] Login funciona
- [ ] Dashboard "PG Overview" muestra métricas
- [ ] Gráficas de CPU, RAM, Disk

---

## 🐛 Troubleshooting

### Problema 1: DNS no resuelve

```bash
dig bitsflaredb.bits.do +short
```

**Si no muestra IP:**
- Esperar 5-30 minutos para propagación DNS
- Verificar configuración en tu DNS provider
- Usar `nslookup bitsflaredb.bits.do 8.8.8.8`

**Workaround temporal:**
```bash
# Usar IP en lugar de dominio
SUPABASE_DOMAIN=194.163.149.70
USE_LETSENCRYPT=false
```

### Problema 2: SSL falla

```bash
./scripts/deploy ssl:status
```

**Causas comunes:**
- DNS no propagado aún
- Puerto 80 cerrado en firewall
- Email inválido en LETSENCRYPT_EMAIL

**Solución:**
```bash
# Verificar puertos
ssh root@194.163.149.70 'ufw status'

# Reintentar SSL
./scripts/deploy ssl:setup
```

### Problema 3: Backblaze B2 upload falla

```bash
# Verificar configuración
ssh root@194.163.149.70 'cd /opt/supabase && cat .env | grep -E "^(S3_|TUS_)"'
```

**Debe mostrar:**
```
S3_BUCKET=bits-supabase-storage
S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
TUS_ALLOW_S3_TAGS=false
```

**Si falta TUS_ALLOW_S3_TAGS:**
```bash
./scripts/deploy storage:b2
```

### Problema 4: PostgreSQL no arranca

```bash
ssh root@194.163.149.70
systemctl status postgres-15
journalctl -u postgres-15 -n 50
```

**Causas comunes:**
- Poco espacio en disco
- Puertos ocupados
- Configuración incorrecta

**Solución:**
```bash
# Verificar espacio
df -h

# Verificar puertos
ss -tulpn | grep -E ":(5432|6432|5436)"

# Reiniciar servicio
systemctl restart postgres-15
```

### Problema 5: docker compose falla

```bash
ssh root@194.163.149.70
cd /opt/supabase
docker compose logs --tail 50
```

**Verificar:**
- Todas las imágenes descargadas: `docker images | grep supabase`
- Contenedores corriendo: `docker compose ps`
- Recursos suficientes: `free -h`

---

## 📊 Resultado Final Esperado

```
✅ VPS Ubuntu limpio
✅ DNS apuntando correctamente
✅ PostgreSQL 17 funcionando
✅ Supabase completo deployado
✅ SSL/TLS con Let's Encrypt
✅ Storage → Backblaze B2
✅ TUS_ALLOW_S3_TAGS=false configurado
✅ pgBackRest → Backups en Backblaze B2
✅ Grafana monitoring activo
✅ Todo accesible en https://bitsflaredb.bits.do
```

### URLs Finales

```
Supabase Studio:   https://bitsflaredb.bits.do
API:               https://bitsflaredb.bits.do/rest/v1
Auth:              https://bitsflaredb.bits.do/auth/v1
Storage:           https://bitsflaredb.bits.do/storage/v1
Realtime:          wss://bitsflaredb.bits.do/realtime/v1
```

### Costos Mensuales

```
VPS (Contabo):     $6.99/mes
Backblaze B2:      ~$0.40/mes (estimado 50GB)
────────────────────────────
Total:             ~$7.39/mes
```

---

## 🎯 Comandos Rápidos Post-Instalación

```bash
# Verificar todo
./scripts/deploy verify

# Test storage
./scripts/deploy storage:test

# Ver estado SSL
./scripts/deploy ssl:status

# Backup manual
ssh root@194.163.149.70 'sudo -iu postgres pgbackrest --stanza=pg-meta backup'

# Ver logs
ssh root@194.163.149.70 'cd /opt/supabase && docker compose logs --tail 100'

# SSH tunnel a Grafana
ssh -L 3000:localhost:3000 root@194.163.149.70
```

---

## 📝 Notas para el Reset

### Antes de resetear el VPS:

1. **Guardar configuración importante:**
   ```bash
   # Tu .env local ya tiene todo
   cat .env
   ```

2. **Verificar backups (opcional):**
   ```bash
   ssh root@194.163.149.70 'sudo -iu postgres pgbackrest --stanza=pg-meta info'
   ```

### Después del reset:

1. **Esperar a que el VPS esté listo** (~2-5 minutos)
2. **Verificar acceso SSH:**
   ```bash
   ssh root@194.163.149.70
   ```
3. **Ejecutar deployment completo:**
   ```bash
   ./scripts/deploy all
   ```

---

## 🎉 Éxito!

Si todos los checks están ✅, tienes:
- Sistema completo en producción
- Backblaze B2 funcionando sin MinIO
- Backups automáticos configurados
- SSL/TLS activo
- Todo documentado

**Tiempo total estimado:** 20-30 minutos

**¿Siguiente paso?** Crear tu primera aplicación conectada a Supabase 🚀
