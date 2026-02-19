# Sure for Home Assistant

Sure is the community-driven personal finance app, adapted as a Home Assistant add-on.
This package is based on the upstream Sure project and is focused on easy self-hosting inside HA.

## What You Get

- Sure opened directly inside Home Assistant via Ingress
- Optional direct access on `http://<ha-host>:1212`
- PostgreSQL + Redis backend support
- Persistent storage in `/data/storage`
- Multi-arch images: `amd64`, `aarch64`

## Quick Start

1. Install and run PostgreSQL and Redis (HA add-ons or external services).
2. Configure add-on options.
3. Start the add-on.
4. Open Sure from the add-on page or HA sidebar.

## Default Options

```yaml
postgres_user: postgres
postgres_password: homeassistant
postgres_db: postgres
secret_key_base: very_very_secret_key
db_host: db21ed7f-postgres-latest
db_port: 5432
redis_url: redis://3b88f413-redis:6379
onboarding_state: open
self_hosted: true
rails_force_ssl: false
rails_assume_ssl: false
```

## Security Notes

- Replace `secret_key_base` before production use.
- Replace `postgres_password` before production use.
- Restrict direct port access (`1212`) if you use Ingress-only mode.

## Attribution

- Upstream project: `https://github.com/we-promise/sure`
- This repository provides Home Assistant packaging and runtime integration.
