# Post-Deployment Automated Fixes

This document explains the automatic fixes applied after Supabase deployment to ensure all services start correctly.

## Overview

The `06-post-supabase.sh` module automatically fixes common issues that occur during Supabase deployment with Pigsty. These fixes run automatically as part of `./scripts/deploy all`.

## Issues Fixed Automatically

### 1. JWT Token Configuration

**Problem**: Pigsty's default Supabase template includes demo JWT tokens that don't match the generated `JWT_SECRET`.

**Solution**: 
- Replaces default JWT tokens in `/opt/supabase/.env` with the correctly generated tokens from local `.env`
- Updates: `JWT_SECRET`, `ANON_KEY`, `SERVICE_ROLE_KEY`

**Files Modified**:
- `/opt/supabase/.env`

### 2. URL-Encoded Database Passwords

**Problem**: PostgreSQL passwords containing special characters (`/`, `+`, `=`) cause URL parsing errors in Docker containers:
```
TypeError: Invalid URL
input: 'postgres://user:password/with+special=chars@host:5436/db'
```

**Solution**:
- Creates `POSTGRES_PASSWORD_ENCODED` variable with URL-encoded password
- Updates `docker-compose.yml` to use `${POSTGRES_PASSWORD_ENCODED}` in all `DATABASE_URL` variables
- Adds explicit `DATABASE_URL` for Auth service

**Special Characters Encoded**:
- `/` → `%2F`
- `+` → `%2B`
- `=` → `%3D`

**Files Modified**:
- `/opt/supabase/.env` - Adds `POSTGRES_PASSWORD_ENCODED`
- `/opt/supabase/docker-compose.yml` - Replaces all `${POSTGRES_PASSWORD}` with `${POSTGRES_PASSWORD_ENCODED}` in DATABASE URLs

### 3. PostgreSQL User Passwords

**Problem**: Pigsty creates Supabase database users but doesn't always apply the correct password from `pigsty.yml` during initial setup.

**Solution**:
- Connects to PostgreSQL and updates all Supabase user passwords using `ALTER USER`
- Updates 7 users: `supabase_auth_admin`, `supabase_storage_admin`, `supabase_functions_admin`, `supabase_replication_admin`, `supabase_read_only_user`, `supabase_admin`, `authenticator`

**Command Example**:
```sql
ALTER USER supabase_auth_admin WITH PASSWORD 'correct_password';
```

### 4. Backblaze B2 Compatibility

**Problem**: Supabase Storage attempts to use `x-amz-tagging` header which Backblaze B2 doesn't support.

**Solution**:
- Adds `TUS_ALLOW_S3_TAGS=false` to `.env` to disable S3 tagging
- Adds `DB_SSL=false` since internal PostgreSQL connections don't use SSL

**Files Modified**:
- `/opt/supabase/.env`

### 5. Container Recreation

**Problem**: Auth and Storage containers cache old environment variables even after `.env` changes.

**Solution**:
- Stops and removes Auth and Storage containers completely
- Recreates them from updated `docker-compose.yml` with new environment variables
- Waits for containers to become healthy (20 seconds)

**Commands**:
```bash
docker compose down auth storage
docker compose up -d auth storage
```

## Manual Execution

If you need to run the fixes manually after deployment:

```bash
./scripts/modules/06-post-supabase.sh
```

## Verification

After running the fixes, verify all services are healthy:

```bash
ssh deploy@YOUR_VPS_IP "docker ps | grep supabase"
```

Expected output (all services should show "healthy" or "Up"):
```
supabase-storage     Up X minutes (healthy)
supabase-auth        Up X minutes (healthy)
supabase-rest        Up X minutes
supabase-kong        Up X minutes (healthy)
supabase-studio      Up X minutes (healthy)
...
```

## Troubleshooting

### Auth or Storage still failing

1. Check logs:
```bash
ssh deploy@YOUR_VPS_IP "docker logs supabase-auth"
ssh deploy@YOUR_VPS_IP "docker logs supabase-storage"
```

2. Verify environment variables:
```bash
ssh deploy@YOUR_VPS_IP "grep -E '(JWT_SECRET|POSTGRES_PASSWORD|DATABASE_URL)' /opt/supabase/.env"
```

3. Check PostgreSQL user passwords:
```bash
ssh deploy@YOUR_VPS_IP "PGPASSWORD='your_password' psql -h 127.0.0.1 -p 5436 -U supabase_auth_admin -d postgres -c 'SELECT current_user;'"
```

### Special characters in passwords

If you still see URL parsing errors, check that `POSTGRES_PASSWORD_ENCODED` is being used in `docker-compose.yml`:

```bash
ssh deploy@YOUR_VPS_IP "grep DATABASE_URL /opt/supabase/docker-compose.yml"
```

Should show: `${POSTGRES_PASSWORD_ENCODED}` not `${POSTGRES_PASSWORD}`

## Files Modified by This Module

| File | Changes | Purpose |
|------|---------|---------|
| `/opt/supabase/.env` | JWT tokens, URL-encoded password, B2 flags | Container environment |
| `/opt/supabase/docker-compose.yml` | Use encoded password in URLs | Fix URL parsing |
| PostgreSQL database | User passwords | Authentication |

## Security Considerations

- All passwords are transmitted over SSH (encrypted)
- Backup files are created with timestamps before modifications
- Original files can be restored from `/opt/supabase/*.backup-YYYYMMDD-HHMMSS`

## Development Notes

This module was created to automate manual fixes that were identified during the initial deployment. All issues have been reproduced and verified fixed in production.

## Related Documentation

- [Backblaze B2 Configuration](./BACKBLAZE-B2-SETUP.md)
- [Troubleshooting Guide](./TROUBLESHOOTING.md)
- [Deployment Process](../README.md)
