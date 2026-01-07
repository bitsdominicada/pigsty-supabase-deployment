# App Schema Workflow

Este documento describe el flujo de trabajo para mantener sincronizado el schema de la aplicación entre servidores.

## Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                     SERVIDOR ORIGEN                              │
│                   (194.163.149.70)                               │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  PostgreSQL                                              │   │
│  │  ├── Schema: public (tablas de aplicación)              │   │
│  │  ├── Schema: app (funciones de aplicación)              │   │
│  │  ├── Schema: util (utilidades)                          │   │
│  │  └── Schema: pgmq (colas de mensajes)                   │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ ./scripts/deploy-simple sync-schema
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     PROYECTO LOCAL                               │
│               (pigsty-supabase-deployment)                       │
│                                                                  │
│  config/app_schema/                                              │
│  └── app_schema.sql  ◄─── Schema exportado automáticamente     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ ./scripts/deploy-simple apply-schema
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   SERVIDOR DESTINO                               │
│              (Nuevo VPS / Staging / etc.)                        │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  PostgreSQL                                              │   │
│  │  └── Schema aplicado desde app_schema.sql               │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## Comandos Disponibles

### Sincronizar Schema desde Origen

Exporta el schema actual del servidor origen y lo guarda en `config/app_schema/app_schema.sql`:

```bash
./scripts/deploy-simple sync-schema

# O especificar IP diferente
./scripts/deploy-simple sync-schema 194.163.149.70
```

**Cuándo usar:**
- Después de hacer cambios en el schema del origen (nuevas tablas, columnas, funciones, etc.)
- Antes de desplegar un nuevo VPS
- Periódicamente para mantener el schema actualizado

### Aplicar Schema en VPS Destino

Aplica el schema guardado en `app_schema.sql` a un servidor destino:

```bash
# Usar VPS_HOST del .env
./scripts/deploy-simple apply-schema

# O especificar IP diferente
./scripts/deploy-simple apply-schema 167.114.2.209
```

**Cuándo usar:**
- Después de un nuevo deployment (`deploy-simple all`)
- Para sincronizar un servidor staging/desarrollo con producción
- Para restaurar el schema en un servidor limpio

## Flujo de Trabajo Recomendado

### 1. Desarrollo en Origen

Cuando hagas cambios en el servidor origen (194.163.149.70):

```sql
-- Ejemplo: Agregar nueva columna
ALTER TABLE public.employees ADD COLUMN new_field text;

-- Ejemplo: Crear nueva tabla
CREATE TABLE public.new_feature (...);

-- Ejemplo: Agregar función
CREATE OR REPLACE FUNCTION app.my_function() ...
```

### 2. Sincronizar Schema

Después de hacer cambios, sincroniza el schema:

```bash
./scripts/deploy-simple sync-schema
```

Esto actualiza `config/app_schema/app_schema.sql` con todos los cambios.

### 3. Commit de Cambios

Commitea el schema actualizado para que esté disponible en nuevos deployments:

```bash
git add config/app_schema/app_schema.sql
git commit -m "feat: Update app schema with new_field column"
git push
```

### 4. Aplicar en Otros Servidores

Para aplicar los cambios en staging u otros servidores:

```bash
# Aplicar en staging
./scripts/deploy-simple apply-schema 167.114.2.209

# Aplicar en otro servidor
./scripts/deploy-simple apply-schema 10.0.0.5
```

## Contenido del Schema

El archivo `app_schema.sql` incluye:

| Componente | Descripción |
|------------|-------------|
| **ENUMs** | Tipos enumerados personalizados |
| **Tablas** | Todas las tablas de la aplicación (public, app, util) |
| **Funciones** | Funciones PL/pgSQL de la aplicación |
| **Triggers** | Triggers para automatización |
| **Índices** | Índices para optimización de consultas |
| **Policies** | Políticas de Row Level Security (RLS) |
| **Constraints** | Foreign keys y check constraints |

**NO incluye** (manejado por Supabase baseline):
- Schema `auth.*` (autenticación)
- Schema `storage.*` (almacenamiento)
- Schema `realtime.*` (websockets)
- Schema `supabase_functions.*`
- Extensiones de PostgreSQL

## Estructura de Archivos

```
pigsty-supabase-deployment/
├── config/
│   └── app_schema/
│       └── app_schema.sql      # Schema de aplicación (auto-generado)
│
├── scripts/
│   ├── deploy-simple           # Script principal con comandos
│   └── modules/
│       ├── 14-sync-app-schema.sh   # Sincronizar desde origen
│       └── 15-apply-app-schema.sh  # Aplicar en destino
│
└── docs/
    └── APP_SCHEMA_WORKFLOW.md  # Esta documentación
```

## Solución de Problemas

### Error: "No se puede conectar"

Verificar que la SSH key está configurada:

```bash
ssh -i ~/.ssh/pigsty_deploy deploy@194.163.149.70 "echo OK"
```

### Error: "Tabla ya existe"

Es normal si la tabla ya fue creada. El script usa `IF NOT EXISTS` para evitar errores.

### Error: "Función ya existe"

Las funciones se crean con `CREATE OR REPLACE`, así que se actualizan automáticamente.

### Schema incompleto

Si el schema parece incompleto, verifica que el servidor origen tiene todos los cambios:

```bash
# Verificar tablas en origen
ssh -i ~/.ssh/pigsty_deploy deploy@194.163.149.70 \
  "sudo -u postgres psql -d postgres -c \"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public'\""
```

## Buenas Prácticas

1. **Sincroniza frecuentemente**: Después de cada cambio significativo en el origen
2. **Commitea siempre**: El `app_schema.sql` debe estar en git
3. **Revisa antes de aplicar**: Verifica qué contiene el schema antes de aplicarlo
4. **Backup primero**: Haz backup del destino antes de aplicar cambios grandes
5. **Usa staging**: Prueba en staging antes de aplicar en producción

## Integración con CI/CD

Para automatizar en un pipeline:

```yaml
# .github/workflows/sync-schema.yml
name: Sync Schema

on:
  schedule:
    - cron: '0 0 * * *'  # Diario a medianoche
  workflow_dispatch:

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup SSH
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.DEPLOY_KEY }}" > ~/.ssh/pigsty_deploy
          chmod 600 ~/.ssh/pigsty_deploy
          
      - name: Sync Schema
        run: ./scripts/deploy-simple sync-schema
        
      - name: Commit Changes
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add config/app_schema/app_schema.sql
          git diff --staged --quiet || git commit -m "chore: Auto-sync app schema"
          git push
```
