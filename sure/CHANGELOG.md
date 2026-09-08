# Changelog

## 0.7.5.4

- Switch the add-on version to a numeric format so Home Assistant correctly detects the update and enables the Update button.
- Keep the Sure base image at `0.7.5-alpha.7-ha-2`; the add-on version is tracked separately from the upstream version.

## 0.7.5-alpha.7-ha-3

- Update the Sure base image to `0.7.5-alpha.7-ha-2` for amd64 and aarch64.
- Replace the unavailable `stable` base image tag with an explicit version in the Dockerfile and release workflow.

## 0.7.5-alpha.7-ha-2

- Update upstream

## 0.7.5-alpha.7-ha-1

- Update upstream

## 0.6.8-alpha.13-ha-7

- Rebased README on upstream Sure with explicit Home Assistant add-on positioning.
- Added notes about HA auto-login, Russian language support, and bug fixes.
- Renamed Home Assistant ingress tab title to `Финансы`.


## 0.6.11

- Bumped add-on version to `0.6.11`.

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
