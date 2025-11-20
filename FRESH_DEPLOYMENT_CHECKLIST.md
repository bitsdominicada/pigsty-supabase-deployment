# ✅ Fresh Deployment Checklist

## Pre-requisitos (Ya configurados)

- ✅ `.env` configurado con todas las credenciales
- ✅ Dominio `bitsflaredb.bits.do` apunta a `194.163.149.70`
- ✅ `USE_LETSENCRYPT=true` en `.env`
- ✅ Backblaze B2 credenciales configuradas
- ✅ SSH keys configuradas

## Comando de Deployment

Después de resetear el VPS a Ubuntu 24.04 limpio:

```bash
./scripts/deploy all
```

## Lo que hará automáticamente:

### 1️⃣ Preparación VPS (01-prepare.sh)
- Crear usuario `deploy`
- Configurar SSH keys
- Instalar dependencias básicas

### 2️⃣ Configuración Pigsty (02-configure.sh)
- Descargar Pigsty v3.6.1
- Generar `pigsty.yml` con:
  - Credenciales de `.env`
  - Configuración de `infra_portal.supa` para SSL
  - PostgreSQL passwords
  - Backblaze B2 para pgBackRest

### 3️⃣ Instalación (03-install.sh)
- PostgreSQL 17 + Patroni (HA)
- Docker
- Supabase completo

### 4️⃣ Post-deployment Fixes (06-post-supabase.sh)
- Fix #1: `POSTGRES_HOST=172.17.0.1`
- Fix #2: `pg_hba.conf` regla para VPS IP
- Fix #3: Password `supabase_admin`
- Fix #4: `docker-compose.yml` analytics DB_PASSWORD
- Fix #5: `POSTGRES_PASSWORD` correcto en .env

### 5️⃣ Configuración Backblaze B2 (09-configure-b2-storage.sh)
- Actualizar `.env` con credenciales B2
- Configurar bucket `bits-supabase-storage`
- Reiniciar storage container

### 6️⃣ SSL/HTTPS (08-ssl-setup.sh)
- Solicitar certificado Let's Encrypt
- Configurar nginx automáticamente
- Actualizar URLs de Supabase a HTTPS
- Reiniciar contenedores

## Resultado Esperado

**Servicios:**
- 11/11 contenedores Supabase healthy
- PostgreSQL 17 con Patroni
- Backblaze B2 storage funcionando
- SSL/HTTPS activo

**URLs:**
- 🔐 Studio: https://bitsflaredb.bits.do
- 🔐 API: https://bitsflaredb.bits.do/rest/v1
- 📊 Grafana: http://194.163.149.70:3000
- 🗄️ PostgreSQL: 194.163.149.70:5436

## Tiempo Estimado

- **Preparación VPS**: ~2 minutos
- **Instalación Pigsty**: ~8-10 minutos
- **Post-fixes**: ~1 minuto
- **SSL setup**: ~2 minutos
- **Total**: ~15 minutos

## Verificación Post-Deployment

```bash
# Verificar servicios
./scripts/deploy verify

# Test Backblaze B2
./scripts/deploy storage:test

# Ver estado SSL
./scripts/deploy ssl:status
```

## ⚠️ Notas Importantes

1. **DNS debe estar resuelto**: `bitsflaredb.bits.do` → `194.163.149.70`
2. **Puerto 80 abierto**: Necesario para validación Let's Encrypt
3. **Puerto 443 abierto**: Para HTTPS
4. **Puerto 8000 abierto**: Kong API Gateway

## 🎯 Zero Manual Intervention

Todo está automatizado. No necesitas:
- ❌ Editar archivos manualmente
- ❌ Ejecutar comandos SSH
- ❌ Configurar certificados
- ❌ Reiniciar servicios manualmente

Solo ejecuta `./scripts/deploy all` y espera! 🚀
