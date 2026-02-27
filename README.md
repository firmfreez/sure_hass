# Sure for Home Assistant

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/we-promise/sure)

# Sure: The personal finance app for everyone

Get involved (upstream): [Discord](https://discord.gg/36ZGBsxYEK) • [Website](https://sure.am) • [Issues](https://github.com/we-promise/sure/issues)

> [!IMPORTANT]
> This repository packages **Sure** as a **Home Assistant add-on** (Hass integration).
> It is based on the upstream community project `we-promise/sure`.

## What is included in this Home Assistant fork

Everything from upstream Sure, plus Home Assistant integration:

- Ingress launch inside Home Assistant sidebar
- Home Assistant auto-login (`ha_ingress_auto_login`)
- Russian language support
- Several bug fixes for add-on packaging/runtime

## Backstory (from upstream Sure)

The Maybe Finance team spent most of 2021-2022 building a full-featured personal finance and wealth management app.
The business did not survive, and development stopped in 2023.
After being open-sourced, the codebase was continued by the community as `Sure`.

## Hosting Sure

Sure is a fully working personal finance app. In this repository it is distributed as a Home Assistant add-on.

Quick start:

1. Install PostgreSQL and Redis (HA add-ons or external services).
2. Configure add-on options.
3. Start the add-on.
4. Open it from the Home Assistant sidebar (Ingress).

## Default add-on options

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
ha_ingress_auto_login: true
```

## Security notes

- Replace `secret_key_base` before production use.
- Replace `postgres_password` before production use.
- Restrict direct port access (`1212`) if you use Ingress-only mode.

## Forking and attribution

This add-on is based on upstream `we-promise/sure` (AGPLv3).
It is not affiliated with or endorsed by Maybe Finance Inc.

- Upstream project: https://github.com/we-promise/sure
- This repository: Home Assistant packaging and runtime integration only

## License and trademarks

- Sure is distributed under AGPLv3.
- "Maybe" is a trademark of Maybe Finance, Inc.
