# Actualizar Supabase a Versiones Oficiales Más Recientes

## 🎯 Overview

Pigsty incluye Supabase pero puede tener versiones desactualizadas. Esta guía te muestra cómo actualizar a las últimas versiones oficiales de Supabase.

## 📊 Comparación de Versiones Actual

| Servicio | Pigsty | Supabase Oficial | Estado |
|----------|--------|------------------|--------|
| **Studio** | 2025.06.16 | 2025.11.10 | ⚠️ 5 meses atrás |
| **Auth** | v2.174.0 | v2.182.1 | ⚠️ 8 versiones |
| **Rest** | v12.2.12 | **v13.0.7** | ⚠️ Major version |
| **Realtime** | v2.34.47 | v2.63.0 | ⚠️ 28 versiones |
| **Storage** | v1.23.0 | v1.29.0 | ⚠️ 6 versiones |
| **Meta** | v0.89.3 | v0.93.1 | ⚠️ 4 versiones |
| **Functions** | v1.67.4 | v1.69.23 | ⚠️ 2 versiones |
| **Analytics** | 1.15.4 | 1.22.6 | ⚠️ 7 versiones |

## 🚀 Método 1: Script Automático (Recomendado)

```bash
# Actualizar todas las versiones
./scripts/deploy update:supabase
```

**El script:**
1. ✅ Muestra versiones actuales vs últimas
2. ✅ Hace backup del docker-compose.yml
3. ✅ Actualiza todas las versiones
4. ✅ Descarga nuevas imágenes
5. ✅ Te pregunta cómo recrear contenedores
6. ✅ Verifica que todo funcione

**Opciones de recreación:**
- **Opción 1:** Recrear todos (downtime ~2 min)
- **Opción 2:** Recrear uno por uno (downtime mínimo)
- **Opción 3:** Solo descargar (actualizar después)

## 🔧 Método 2: Actualización Manual

### Paso 1: Verificar Versiones Actuales

```bash
ssh root@<VPS_IP>
cd /opt/supabase
grep "image:" docker-compose.yml | grep -E "(supabase|postgrest)"
```

### Paso 2: Hacer Backup

```bash
cd /opt/supabase
cp docker-compose.yml docker-compose.yml.backup.$(date +%Y%m%d_%H%M%S)
```

### Paso 3: Editar docker-compose.yml

```bash
nano docker-compose.yml
```

Actualizar estas líneas:

```yaml
services:
  studio:
    image: supabase/studio:2025.11.10-sha-5291fe3  # ← Cambiar

  auth:
    image: supabase/gotrue:v2.182.1  # ← Cambiar

  rest:
    image: postgrest/postgrest:v13.0.7  # ← Cambiar

  realtime:
    image: supabase/realtime:v2.63.0  # ← Cambiar

  storage:
    image: supabase/storage-api:v1.29.0  # ← Cambiar

  meta:
    image: supabase/postgres-meta:v0.93.1  # ← Cambiar

  functions:
    image: supabase/edge-runtime:v1.69.23  # ← Cambiar

  analytics:
    image: supabase/logflare:1.22.6  # ← Cambiar
```

### Paso 4: Descargar Nuevas Imágenes

```bash
docker compose pull
```

### Paso 5: Recrear Contenedores

**Opción A: Todos a la vez (downtime ~2 min)**
```bash
docker compose down
docker compose up -d
```

**Opción B: Uno por uno (downtime mínimo)**
```bash
# Studio
docker compose stop studio && docker compose rm -f studio && docker compose up -d studio

# Auth
docker compose stop auth && docker compose rm -f auth && docker compose up -d auth

# Rest
docker compose stop rest && docker compose rm -f rest && docker compose up -d rest

# Realtime
docker compose stop realtime && docker compose rm -f realtime && docker compose up -d realtime

# Storage
docker compose stop storage && docker compose rm -f storage && docker compose up -d storage

# Meta
docker compose stop meta && docker compose rm -f meta && docker compose up -d meta

# Functions
docker compose stop functions && docker compose rm -f functions && docker compose up -d functions

# Analytics
docker compose stop analytics && docker compose rm -f analytics && docker compose up -d analytics
```

### Paso 6: Verificar

```bash
docker compose ps
docker compose logs --tail 50
```

## ⚠️ Cambios Importantes por Versión

### PostgREST v12 → v13 (Major Version)

**Cambios breaking:**
- Nueva sintaxis para algunas queries
- Cambios en headers HTTP
- Mejoras de performance

**Verificar después de actualizar:**
```bash
# Test API
curl https://bitsflaredb.bits.do/rest/v1/
```

### Storage v1.23 → v1.29

**Mejoras:**
- Mejor manejo de S3
- Fix para x-amz-tagging (ya lo tienes con TUS_ALLOW_S3_TAGS=false)
- Mejoras de performance

### Realtime v2.34 → v2.63

**Mejoras:**
- Mejor gestión de conexiones WebSocket
- Reducción de uso de memoria
- Mejoras en presencia

## 🔙 Rollback si Algo Falla

### Restaurar Versión Anterior

```bash
ssh root@<VPS_IP>
cd /opt/supabase

# Listar backups
ls -lh docker-compose.yml.backup.*

# Restaurar (usar el timestamp correcto)
cp docker-compose.yml.backup.20251120_140000 docker-compose.yml

# Recrear contenedores
docker compose down
docker compose up -d
```

## 📋 Checklist de Actualización

Antes de actualizar:
- [ ] Hacer backup de `/opt/supabase/docker-compose.yml`
- [ ] Verificar espacio en disco (`df -h`)
- [ ] Notificar usuarios (si aplica)
- [ ] Tener backup reciente de la base de datos

Durante la actualización:
- [ ] Descargar nuevas imágenes
- [ ] Verificar que las imágenes se descargaron correctamente
- [ ] Recrear contenedores
- [ ] Esperar a que los servicios estén healthy

Después de actualizar:
- [ ] Verificar que Supabase Studio funcione
- [ ] Probar API REST
- [ ] Probar Auth (login/logout)
- [ ] Probar Storage (upload/download)
- [ ] Probar Realtime (subscriptions)
- [ ] Verificar logs por errores

## 🔍 Verificación Post-Actualización

### 1. Health Check Completo

```bash
./scripts/deploy verify
```

### 2. Verificar Versiones

```bash
ssh root@<VPS_IP> 'cd /opt/supabase && docker compose ps'
```

### 3. Test API

```bash
# REST API
curl https://bitsflaredb.bits.do/rest/v1/

# Auth
curl https://bitsflaredb.bits.do/auth/v1/health

# Storage
curl https://bitsflaredb.bits.do/storage/v1/bucket
```

### 4. Test Storage Upload

```bash
./scripts/deploy storage:test
```

### 5. Verificar Logs

```bash
ssh root@<VPS_IP>
cd /opt/supabase

# Ver logs de todos los servicios
docker compose logs --tail 100

# Ver logs de un servicio específico
docker compose logs storage --tail 50
docker compose logs auth --tail 50
```

## 🔄 Mantener Actualizado

### Opción 1: Actualización Periódica

Crear un recordatorio mensual:
```bash
# Verificar nuevas versiones
curl -s https://raw.githubusercontent.com/supabase/supabase/master/docker/docker-compose.yml | grep "image:" | grep supabase
```

### Opción 2: GitHub Watch

1. Ve a https://github.com/supabase/supabase
2. Click en "Watch" → "Custom" → "Releases"
3. Recibirás notificaciones de nuevas versiones

### Opción 3: Script Automatizado

Crear cron job para verificar actualizaciones:

```bash
# Agregar a crontab (verifica cada lunes)
0 9 * * 1 /root/check-supabase-updates.sh
```

## 📚 Referencias

- [Supabase Releases](https://github.com/supabase/supabase/releases)
- [Supabase Docker](https://github.com/supabase/supabase/tree/master/docker)
- [PostgREST Changelog](https://github.com/PostgREST/postgrest/releases)
- [Pigsty Apps](https://github.com/pgsty/pigsty/tree/main/app/supabase)

## ⚡ Actualización Express

Si tienes prisa:

```bash
# 1. Backup automático + Actualización
./scripts/deploy update:supabase

# 2. Selecciona opción 1 (recrear todos)

# 3. Verifica
./scripts/deploy verify

# 4. Listo! ✅
```

---

## 💡 Consejos

- **Actualiza en horario de bajo tráfico**
- **Haz backup antes de actualizar**
- **Prueba en entorno de desarrollo primero** (si tienes uno)
- **Lee los changelogs** de versiones con cambios breaking
- **Ten el backup a mano** por si necesitas rollback

## 🎯 Resumen

| Método | Tiempo | Complejidad | Downtime |
|--------|--------|-------------|----------|
| Script automático | 5 min | Fácil | 2 min |
| Manual todos | 10 min | Media | 2 min |
| Manual uno por uno | 20 min | Media | ~30 seg |

**Recomendado:** Script automático con opción 1 (recrear todos)
