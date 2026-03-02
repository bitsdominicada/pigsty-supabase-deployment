# Provider Templates (Upstream Pigsty)

This folder stores cloud Terraform templates pulled from upstream Pigsty.

Upstream source:
- https://github.com/pgsty/pigsty/tree/v4.2.0/terraform/spec

Providers included in this v2 workflow:
- `hetzner`
- `digitalocean`
- `aws`
- `gcp`
- `azure`
- `vultr`
- `linode`
- `aliyun`
- `qcloud`

Use the helper to pull/update templates:

```bash
./v2/bin/pigsty-v2 provider pull hetzner v4.2.0
./v2/bin/pigsty-v2 provider pull digitalocean v4.2.0
```

Then activate one template:

```bash
./v2/bin/pigsty-v2 provider use hetzner
```
