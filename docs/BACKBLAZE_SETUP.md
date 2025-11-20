# Configuración de Backblaze B2 para Supabase Storage

Esta guía te ayuda a configurar Backblaze B2 como backend de almacenamiento S3 para Supabase, en lugar de usar MinIO local.

## ¿Por qué Backblaze B2?

- **Más económico**: $6/TB/mes vs MinIO que consume recursos del VPS
- **Sin gestión**: No necesitas mantener MinIO
- **Escalable**: Crece automáticamente según tus necesidades
- **Confiable**: 99.9% uptime SLA
- **Compatible S3**: API compatible con Amazon S3

---

## Paso 1: Crear Cuenta en Backblaze

1. Ve a https://www.backblaze.com/b2/sign-up.html
2. Crea tu cuenta (gratis: 10GB storage + 1GB download/día)

---

## Paso 2: Crear Bucket

1. Inicia sesión en https://secure.backblaze.com
2. Ve a **B2 Cloud Storage** → **Buckets**
3. Click **Create a Bucket**
4. Configuración:
   - **Bucket Name**: `supabase-storage` (o el nombre que prefieras)
   - **Files in Bucket**: **Private**
   - **Default Encryption**: **Disabled** (Supabase maneja encriptación)
   - **Object Lock**: **Disabled**
5. Click **Create a Bucket**

---

## Paso 3: Crear Application Key

1. Ve a **App Keys** en el menú lateral
2. Click **Add a New Application Key**
3. Configuración:
   - **Name**: `bits-flare` (o nombre descriptivo)
   - **Allow access to Bucket(s)**: Selecciona tu bucket `supabase-storage`
   - **Type of Access**: **Read and Write**
   - **Allow List All Bucket Names**: ✅ (recomendado)
   - **File name prefix**: Dejar vacío
   - **Duration**: Unlimited (o según tus políticas)
4. Click **Create New Key**

**⚠️ IMPORTANTE**: Guarda las credenciales inmediatamente, solo se muestran una vez:

```
keyID: 0054f413fc50d980000000003
keyName: bits-flare
applicationKey: K005clOQr83kINWjCg9fWQ7GxaVsLY0
```

---

## Paso 4: Obtener Endpoint S3

El endpoint depende de la región de tu bucket:

1. Ve a tu bucket en **B2 Cloud Storage** → **Buckets**
2. Click en el nombre del bucket
3. En **Bucket Settings**, busca **Endpoint**
4. Copia el **S3 Compatible API Endpoint**

Ejemplo: `s3.us-west-004.backblazeb2.com`

### Endpoints por Región:

| Región | Endpoint |
|--------|----------|
| US West 001 | `s3.us-west-001.backblazeb2.com` |
| US West 002 | `s3.us-west-002.backblazeb2.com` |
| US West 004 | `s3.us-west-004.backblazeb2.com` |
| US East 005 | `s3.us-east-005.backblazeb2.com` |
| EU Central 003 | `s3.eu-central-003.backblazeb2.com` |

---

## Paso 5: Configurar en Pigsty Supabase

### Opción A: Usar plantilla Backblaze

```bash
cp .env.backblaze.example .env
vi .env
```

Actualiza con tus credenciales:

```bash
# STORAGE - BACKBLAZE B2
S3_PROVIDER=backblaze

S3_BUCKET=supabase-storage
S3_ENDPOINT=s3.us-west-004.backblazeb2.com
S3_REGION=us-west-004
S3_ACCESS_KEY=0054f413fc50d980000000003
S3_SECRET_KEY=K005clOQr83kINWjCg9fWQ7GxaVsLY0
```

### Opción B: Configurar .env manualmente

Si ya tienes un `.env`, solo cambia la sección de storage:

```bash
# ============================================
# STORAGE - BACKBLAZE B2
# ============================================
S3_PROVIDER=backblaze

# MinIO NOT USED
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=cualquier_valor

# Backblaze B2
S3_BUCKET=supabase-storage
S3_ENDPOINT=s3.us-west-004.backblazeb2.com
S3_REGION=us-west-004
S3_ACCESS_KEY=0054f413fc50d980000000003
S3_SECRET_KEY=K005clOQr83kINWjCg9fWQ7GxaVsLY0
```

---

## Paso 6: Deploy

```bash
./scripts/deploy all
```

El sistema detectará automáticamente que `S3_PROVIDER=backblaze` y configurará Supabase para usar Backblaze B2 en lugar de MinIO.

---

## Verificación

Una vez completado el deploy:

1. **Verifica la configuración en el VPS:**

```bash
ssh -i ~/.ssh/pigsty_deploy deploy@VPS_IP
cat /opt/supabase/.env | grep S3_
```

Deberías ver:

```
S3_BUCKET=supabase-storage
S3_ENDPOINT=https://s3.us-west-004.backblazeb2.com
S3_REGION=us-west-004
S3_ACCESS_KEY=0054f413fc50d980000000003
S3_SECRET_KEY=K005clOQr83kINWjCg9fWQ7GxaVsLY0
S3_FORCE_PATH_STYLE=false
S3_PROTOCOL=https
```

2. **Prueba subir un archivo en Supabase Studio:**

   - Ve a https://bitsflaredb.bits.do
   - Storage → Files
   - Crea un bucket de prueba
   - Sube un archivo
   - Verifica que aparezca en Backblaze B2

---

## Diferencias MinIO vs Backblaze

| Característica | MinIO (Local) | Backblaze B2 |
|----------------|---------------|--------------|
| **Costo VPS** | Consume RAM/CPU | No consume recursos |
| **Costo Storage** | Incluido en VPS | $6/TB/mes |
| **Escalabilidad** | Limitado por disco | Ilimitado |
| **Backup** | Manual | Automático |
| **Latencia** | ~1ms (local) | ~50-100ms |
| **Gestión** | Requiere mantenimiento | Totalmente gestionado |
| **S3_FORCE_PATH_STYLE** | `true` | `false` |

---

## Troubleshooting

### Error: "Access Denied"

**Causa**: Application Key sin permisos correctos.

**Solución**: 
1. Verifica que la Application Key tenga **Read and Write**
2. Verifica que esté asociada al bucket correcto
3. Regenera la Application Key si es necesario

### Error: "Bucket not found"

**Causa**: Nombre del bucket incorrecto o región incorrecta.

**Solución**:
1. Verifica el nombre exacto del bucket (case-sensitive)
2. Verifica que `S3_ENDPOINT` coincida con la región del bucket

### Error: "Invalid endpoint"

**Causa**: Endpoint incorrecto para la región.

**Solución**:
1. Ve al bucket en Backblaze
2. Copia el **S3 Compatible API Endpoint** exacto
3. NO incluyas `https://` en `S3_ENDPOINT` (se agrega automáticamente)

### Los archivos no se ven en Backblaze

**Causa**: Bucket privado + Sin configuración de CORS.

**Solución**:
Agrega reglas CORS en Backblaze:
1. Ve a tu bucket → **Bucket Settings**
2. **CORS Rules** → **Add Rule**
3. Configuración:
```json
{
  "corsRuleName": "supabase-storage",
  "allowedOrigins": [
    "https://bitsflaredb.bits.do"
  ],
  "allowedOperations": [
    "s3_get",
    "s3_head",
    "s3_put",
    "s3_delete"
  ],
  "allowedHeaders": [
    "*"
  ],
  "exposeHeaders": [],
  "maxAgeSeconds": 3600
}
```

---

## Costos Estimados

### Backblaze B2 Pricing:

- **Storage**: $6/TB/mes ($0.006/GB)
- **Download**: $0.01/GB (primeros 3x storage gratis)
- **API Calls**: Gratis (Class B y Class C)

### Ejemplo mensual:
- 10GB almacenados: **$0.06/mes**
- 100GB almacenados: **$0.60/mes**
- 1TB almacenado: **$6/mes**

### Comparación vs MinIO en VPS:
- VPS 2GB RAM extra para MinIO: **~$5-10/mes**
- Backblaze 1TB: **$6/mes**
- **Winner**: Backblaze (más económico y escalable)

---

## Recursos

- **Backblaze B2 Docs**: https://www.backblaze.com/docs/cloud-storage
- **S3 Compatible API**: https://www.backblaze.com/docs/cloud-storage-s3-compatible-api
- **Pricing Calculator**: https://www.backblaze.com/cloud-storage/pricing
- **Supabase Storage Docs**: https://supabase.com/docs/guides/storage

---

## Migración MinIO → Backblaze

Si ya tienes datos en MinIO y quieres migrar a Backblaze:

```bash
# 1. Backup MinIO
ssh deploy@VPS_IP
mc alias set minio https://sss.pigsty:9000 minioadmin PASSWORD
mc mirror minio/data /tmp/minio-backup

# 2. Configurar Backblaze
# (actualizar .env con S3_PROVIDER=backblaze)

# 3. Redesplegar
./scripts/deploy config:sync
./scripts/deploy apply:app

# 4. Subir datos a Backblaze
mc alias set b2 https://s3.us-west-004.backblazeb2.com ACCESS_KEY SECRET_KEY
mc mirror /tmp/minio-backup b2/supabase-storage
```

---

**✅ ¡Listo! Ahora Supabase Storage usa Backblaze B2 en lugar de MinIO.**
