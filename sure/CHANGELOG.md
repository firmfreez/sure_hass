# Changelog

## 0.6.16

- Added Ingress configuration (`ingress`, `ingress_port`).
- Added sidebar panel configuration (`panel_icon`, `panel_title`).
- Switched external port mapping to `1212`.
- Enabled `HA_INGRESS_AUTO_LOGIN` by default (through `ha_ingress_auto_login: true`) for Home Assistant account auto-login.
- Updated add-on defaults:
  - `postgres_user: postgres`
  - `postgres_password: homeassistant`
  - `postgres_db: postgres`
  - `secret_key_base: very_very_secret_key`
  - `db_host: db21ed7f-postgres-latest`
  - `db_port: 5432`
  - `redis_url: redis://3b88f413-redis:6379`
  - `onboarding_state: open`
  - `self_hosted: true`
  - `rails_force_ssl: false`
  - `rails_assume_ssl: false`
- Reworked add-on description and README for Sure + Home Assistant.
- Replaced add-on branding graphics with upstream Sure assets (`icon.png`, `logo.png`).
- Normalized branding asset sizes for Home Assistant (`icon.png` 128x128, `logo.png` 250x100).
- Simplified `onboarding_state` schema type to `str?` for safer config validation.
