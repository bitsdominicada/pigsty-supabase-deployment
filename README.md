# Pigsty Supabase Deployment (V2 Only)

This repository now uses **only V2**.

- Main entrypoint: `./v2/bin/pigsty-v2`
- V2 guide: [`v2/README.md`](./v2/README.md)
- Legacy scripts/docs were removed to avoid confusion.

## Quick Start

```bash
cp v2/.env.example v2/.env
# fill values

./v2/bin/pigsty-v2 validate
./v2/bin/pigsty-v2 install
./v2/bin/pigsty-v2 supabase
./v2/bin/pigsty-v2 verify
```

## Tailscale SSH

V2 now supports using your tailnet as the admin path to `pg-meta`.

Set these in `v2/.env.example`:

```bash
SSH_TRANSPORT=tailscale
TAILSCALE_META_HOST=pg-meta.your-tailnet.ts.net
TAILSCALE_DB1_HOST=pg-data-1.your-tailnet.ts.net
TAILSCALE_DB2_HOST=pg-data-2.your-tailnet.ts.net
```

Then validate connectivity with:

```bash
tailscale ping pg-meta.your-tailnet.ts.net
tailscale ssh root@pg-meta 'hostname'
tailscale ssh root@pg-data-1 'hostname'
tailscale ssh root@pg-data-2 'hostname'
```

## DNS And Certificates

`home`, `app`, `pos`, `ai`, `api`, and `studio` must resolve publicly to `META_IP` before `./v2/bin/pigsty-v2 supabase` can obtain Let's Encrypt certificates. If you set `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ZONE_ID`, the `supabase` phase will upsert those `A` records automatically; otherwise create them manually.

## Edge Functions

Deploy all functions from your app repo:

```bash
./v2/bin/pigsty-v2 functions deploy --source /abs/path/to/bits_flare_platform/supabase/functions
./v2/bin/pigsty-v2 functions smoke --mode safe
```

Or run both:

```bash
./v2/bin/pigsty-v2 functions all --source /abs/path/to/bits_flare_platform/supabase/functions --mode safe
```
