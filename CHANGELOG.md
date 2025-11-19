# Changelog

## v2.0.0 - Complete Refactoring (2025-01-19)

### Breaking Changes
- Complete restructure of scripts directory
- New single-command interface: `./scripts/deploy`
- Updated `.env` format (removed unnecessary variables)

### Added
- **Modular architecture**: Clean separation with `scripts/modules/`
- **Official template integration**: Uses Pigsty's `./configure -c app/supa`
- **Auto-generated JWT tokens**: No manual generation needed
- **Shared utilities**: Common functions in `utils.sh`
- **Better error handling**: Fail-fast with validation
- **Health check module**: Comprehensive verification
- **Migration guide**: `MIGRATION.md` for existing users
- **Quick start**: `QUICKSTART.md` for new users

### Improved
- **70 lines fewer code**: From ~350 to ~280 lines
- **Better maintainability**: Follows official Pigsty patterns
- **Cleaner .env**: Only essential variables
- **Single entry point**: One command to deploy
- **Better documentation**: Clear, concise README

### Removed
- `01-prepare-vps.sh` → `scripts/modules/01-prepare.sh`
- `02-deploy-pigsty.sh` → `scripts/modules/03-install.sh`
- `generate-jwt-keys.sh` → Auto-generated in configure module
- `generate-pigsty-config.sh` → Uses official template
- `health-check.sh` → `scripts/modules/04-verify.sh`
- `setup-backup.sh` → Integrated in Pigsty defaults
- `setup-ssl.sh` → Integrated in configure module
- `config/` directory → Generated on VPS
- `docs/` directory → Consolidated into README

### Migration
Old scripts moved to `.old-scripts/` for reference.
See `MIGRATION.md` for detailed migration instructions.

## v1.0.0 - Initial Release

- Initial automation for Pigsty + Supabase deployment
- Multiple script approach
- Custom configuration generation
