# Migration Guide

## Changes in v2.0

This version has been completely refactored for simplicity and maintainability.

### What Changed

**Before (v1.x):**
```
scripts/
├── 01-prepare-vps.sh
├── 02-deploy-pigsty.sh
├── generate-jwt-keys.sh
├── generate-pigsty-config.sh
├── health-check.sh
├── setup-backup.sh
└── setup-ssl.sh
```

**Now (v2.0):**
```
scripts/
├── deploy              # Single entry point
├── utils.sh            # Shared utilities
└── modules/
    ├── 01-prepare.sh   # VPS setup
    ├── 02-configure.sh # Config (uses official template)
    ├── 03-install.sh   # Installation
    └── 04-verify.sh    # Health check
```

### Key Improvements

1. **Uses Official Template**: Now uses Pigsty's `./configure -c app/supa` instead of custom generation
2. **Single Command**: `./scripts/deploy all` instead of multiple scripts
3. **Modular**: Clean separation of concerns
4. **Auto-generates JWT**: No need for separate script
5. **Cleaner .env**: Removed unnecessary variables

### Migration Steps

If you have an existing `.env` file:

```bash
# Backup your current .env
cp .env .env.backup

# Compare with new example
diff .env.backup .env.example

# Update .env with new format (removed variables):
# - POSTGRES_VERSION (auto-detected)
# - BACKUP_RETENTION_DAYS (configured in Pigsty)
# - BACKUP_SCHEDULE (configured in Pigsty)
# - VPS_SSH_PORT (defaults to 22)
# - SUPABASE_DOMAIN (optional, only if using custom domain)
```

### New Usage

**Old way:**
```bash
./scripts/01-prepare-vps.sh
./scripts/02-deploy-pigsty.sh
./scripts/health-check.sh
```

**New way:**
```bash
./scripts/deploy all
# or step by step:
./scripts/deploy prepare
./scripts/deploy config
./scripts/deploy install
./scripts/deploy verify
```

### Breaking Changes

- Removed `generate-jwt-keys.sh` → JWT keys auto-generated in configure module
- Removed `generate-pigsty-config.sh` → Uses official template + patches
- Removed `setup-backup.sh` → Backups configured by default in Pigsty
- Removed `setup-ssl.sh` → SSL setup integrated (set USE_LETSENCRYPT=true)

### Rollback

If you need the old scripts:

```bash
# Old scripts moved to .old-scripts/
ls .old-scripts/
```

Or checkout the previous version:
```bash
git log --oneline  # Find previous commit
git checkout <commit-hash> -- scripts/
```

### Benefits of New Architecture

| Aspect | Before | After |
|--------|--------|-------|
| Commands to run | 3-5 scripts | 1 command |
| Lines of code | ~350 | ~280 |
| Config generation | Custom YAML | Official template |
| Maintenance | High | Low |
| Updates | Manual sync | Follow Pigsty |
| Clarity | Multiple files | Single workflow |

### Support

Questions? Open an issue with `[migration]` tag.
