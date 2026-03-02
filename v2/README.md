# Pigsty Supabase V2 (Greenfield)

This is a clean start (`v2`) that runs in parallel with legacy `./deploy`.

Goals:
- Keep legacy flow untouched while building a safer replacement.
- Use upstream Pigsty cloud templates directly (Hetzner, DigitalOcean, AWS, GCP, Azure, etc.).
- Separate concerns: infrastructure provisioning first, app deployment second.

## Phase 0: Infrastructure Baseline

0. Set local credentials via `v2/.env`:

```bash
cp v2/.env.example v2/.env
# Edit v2/.env and set at least VULTR_API_KEY (or your provider token)
```

1. Pull upstream cloud template:

```bash
./v2/bin/pigsty-v2 provider pull hetzner v4.2.0
```

2. Activate provider in local Terraform workspace:

```bash
./v2/bin/pigsty-v2 provider use hetzner
```

3. Run Terraform lifecycle:

```bash
./v2/bin/pigsty-v2 iac init
./v2/bin/pigsty-v2 iac plan
./v2/bin/pigsty-v2 iac apply
```

You can verify env/tooling:

```bash
./v2/bin/pigsty-v2 doctor
```

## Why this approach

- You can compare providers quickly using official Pigsty specs.
- You avoid hardcoding provider logic in your own deployment script.
- You can upgrade Pigsty version by re-pulling templates.

## Next planned phases

- Phase 1: Strict config contract (`.env` + validation)
- Phase 2: Pigsty install/app deploy modules (idempotent)
- Phase 3: Security baseline (least-privilege ports, host-key checks)
- Phase 4: Post-deploy verification and smoke tests
