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
