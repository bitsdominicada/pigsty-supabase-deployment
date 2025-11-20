# Configuración de Backblaze B2 para Supabase Storage

Esta guía te muestra cómo configurar Backblaze B2 como almacenamiento para Supabase Storage, eliminando la necesidad de MinIO local.

## 📋 Requisitos Previos

1. **Cuenta de Backblaze B2** (gratis - 10GB incluidos)
2. **Deployment de Pigsty+Supabase funcionando**
3. **Acceso SSH al VPS**

## 🚀 Opción 1: Configuración Automática (Recomendado)

### Paso 1: Crear Bucket en Backblaze B2

1. Accede a https://secure.backblaze.com/b2_buckets.htm
2. Click en **"Create a Bucket"**
3. Configura:
   - **Bucket Name:** `tu-proyecto-supabase-storage`
   - **Files in Bucket:** Public
   - **Encryption:** Disable
   - **Object Lock:** Disable

### Paso 2: Crear Application Key

1. Ve a https://secure.backblaze.com/app_keys.htm
2. Click en **"Add a New Application Key"**
3. Configura:
   - **Name:** `supabase-storage-key`
   - **Buckets:** Allow access only to your bucket
   - **Permissions:** Read and Write
4. **¡IMPORTANTE!** Guarda el `keyID` y `applicationKey` (solo se muestran una vez)

### Paso 3: Actualizar .env

Agrega estas variables a tu archivo `.env` local:

```bash
# Backblaze B2 Configuration
S3_BUCKET=tu-proyecto-supabase-storage
S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
S3_REGION=us-east-005
S3_ACCESS_KEY=<tu-keyID>
S3_SECRET_KEY=<tu-applicationKey>
S3_FORCE_PATH_STYLE=false
S3_PROTOCOL=https
```

**Nota:** Reemplaza `us-east-005` con tu región de Backblaze B2.

### Paso 4: Aplicar Configuración

Ejecuta el comando de configuración automática:

```bash
./scripts/deploy storage:b2
```

Este comando:
- ✅ Actualiza `/opt/supabase/.env` con Backblaze B2
- ✅ Agrega `TUS_ALLOW_S3_TAGS=false` al docker-compose.yml
- ✅ Recrea el contenedor de storage
- ✅ Verifica la configuración

### Paso 5: Probar

```bash
./scripts/deploy storage:test
```

Deberías ver:
```
✅ SUCCESS! File uploaded to Backblaze B2!
✅ File downloaded successfully
```

## 🔧 Opción 2: Configuración Manual

Si prefieres configurar manualmente:

### 1. Actualizar .env en el VPS

```bash
ssh root@VPS_HOST
cd /opt/supabase
nano .env
```

Agrega:
```bash
S3_BUCKET=tu-proyecto-supabase-storage
S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
S3_REGION=us-east-005
S3_ACCESS_KEY=<tu-keyID>
S3_SECRET_KEY=<tu-applicationKey>
S3_FORCE_PATH_STYLE=false
S3_PROTOCOL=https
TUS_ALLOW_S3_TAGS=false
MINIO_DOMAIN_IP=127.0.0.1
```

### 2. Actualizar docker-compose.yml

```bash
cd /opt/supabase
nano docker-compose.yml
```

En la sección `storage:` → `environment:`, agrega:
```yaml
TUS_ALLOW_S3_TAGS: 'false'
```

### 3. Reiniciar Storage

```bash
cd /opt/supabase
docker compose stop storage
docker compose rm -f storage
docker compose up -d storage
```

### 4. Verificar

```bash
docker compose exec storage env | grep -E "GLOBAL_S3|TUS_ALLOW"
```

Deberías ver:
```
GLOBAL_S3_BUCKET=tu-proyecto-supabase-storage
GLOBAL_S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com
TUS_ALLOW_S3_TAGS=false
```

## 📍 Regiones de Backblaze B2

Reemplaza el endpoint según tu región:

| Región | Endpoint |
|--------|----------|
| us-west-000 | https://s3.us-west-000.backblazeb2.com |
| us-west-001 | https://s3.us-west-001.backblazeb2.com |
| us-west-002 | https://s3.us-west-002.backblazeb2.com |
| us-west-004 | https://s3.us-west-004.backblazeb2.com |
| us-east-005 | https://s3.us-east-005.backblazeb2.com |
| eu-central-003 | https://s3.eu-central-003.backblazeb2.com |

Para verificar tu región, ve a tu bucket en Backblaze y mira el **Endpoint**.

## ❓ Troubleshooting

### Error: "x-amz-tagging not supported"

**Causa:** `TUS_ALLOW_S3_TAGS` no está configurado

**Solución:**
```bash
./scripts/deploy storage:b2
```

### Error: "Invalid credentials"

**Causa:** keyID o applicationKey incorrectos

**Solución:**
1. Verifica las credenciales en `.env`
2. Crea una nueva Application Key en Backblaze
3. Vuelve a ejecutar: `./scripts/deploy storage:b2`

### Storage container no arranca

**Error:** `invalid IP address in add-host`

**Solución:** Agrega `MINIO_DOMAIN_IP=127.0.0.1` al `.env`

### Uploads fallan con 403

**Causa:** Row Level Security (RLS) policies

**Solución:** Usa SERVICE_ROLE_KEY o configura políticas RLS en tu bucket:

```sql
-- Permitir uploads para usuarios autenticados
CREATE POLICY "Allow uploads" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'tu-bucket');
```

## 📊 Verificar Configuración

### Ver configuración actual

```bash
ssh root@VPS_HOST 'cd /opt/supabase && cat .env | grep -E "^(S3_|TUS_)"'
```

### Ver variables en contenedor

```bash
ssh root@VPS_HOST 'cd /opt/supabase && docker compose exec storage env | grep -E "(GLOBAL_S3|TUS_)"'
```

### Ver logs de storage

```bash
ssh root@VPS_HOST 'cd /opt/supabase && docker compose logs storage --tail 50'
```

## 💰 Costos de Backblaze B2

| Servicio | Costo |
|----------|-------|
| **Almacenamiento** | $0.005/GB/mes |
| **Descarga** | Primeras 3x gratis |
| **API Calls (Clase C)** | $0.004 por 10,000 |
| **API Calls (Clase B)** | Gratis |

**Ejemplo con 50GB de archivos:**
- Almacenamiento: 50GB × $0.005 = $0.25/mes
- Descargas: 150GB gratis
- **Total: ~$0.25/mes**

## ✅ Ventajas de Backblaze B2

- ✅ **Ultra barato:** $0.005/GB/mes (20x más barato que AWS S3)
- ✅ **Redundancia geográfica automática**
- ✅ **Sin MinIO local** (simplifica arquitectura)
- ✅ **Escalabilidad ilimitada**
- ✅ **Durabilidad 99.999999999%** (11 nueves)
- ✅ **CDN integrado disponible**

## �� Enlaces Útiles

- [Backblaze B2 Dashboard](https://secure.backblaze.com/b2_buckets.htm)
- [Backblaze B2 S3 API Docs](https://www.backblaze.com/b2/docs/s3_compatible_api.html)
- [Storage Architecture](./STORAGE_ARCHITECTURE.md)
- [Success Story](./BACKBLAZE_B2_SUCCESS.md)

## 🎯 Próximos Pasos

Después de configurar Backblaze B2:

1. **Desactivar MinIO** (ya no es necesario):
   ```bash
   ssh root@VPS_HOST 'systemctl stop minio && systemctl disable minio'
   ```

2. **Configurar pgBackRest** para backups en Backblaze B2:
   ```bash
   # Ya incluido si usaste .env.backblaze.example
   ./scripts/deploy config:sync
   ```

3. **Probar uploads** desde tu aplicación

4. **Monitorear uso** en Backblaze Dashboard

---

## 📝 Resumen

```bash
# 1. Crear bucket y Application Key en Backblaze B2
# 2. Actualizar .env con credenciales
# 3. Aplicar configuración
./scripts/deploy storage:b2

# 4. Probar
./scripts/deploy storage:test

# 5. ¡Listo! Storage funcionando con Backblaze B2
```

**¿Preguntas?** Consulta la [documentación completa](./BACKBLAZE_B2_SUCCESS.md) o abre un issue.
