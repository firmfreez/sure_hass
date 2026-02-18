#!/usr/bin/env bash
set -euo pipefail

echo "[sure-addon] uid=$(id -u) gid=$(id -g)"
ls -l /data /data/options.json || true

CONFIG_PATH="/data/options.json"

log() { echo "[sure-addon] $*"; }
die() { log "ERROR: $*"; exit 1; }

command -v jq >/dev/null 2>&1 || die "jq not found (install it in the image)"

[ -f "$CONFIG_PATH" ] || die "Config file not found: $CONFIG_PATH"

json() { jq -r "$1" "$CONFIG_PATH"; }

to_bool_str() {
  # принимает true/false/строки/пусто -> "true"/"false"
  local v="$1"
  case "${v,,}" in
    true|1|"\"true\"" ) echo "true" ;;
    false|0|"\"false\""|"") echo "false" ;;
    *) echo "$v" ;; # если кто-то передал уже "true"/"false" строкой — оставим как есть
  esac
}

# -------- Required --------
POSTGRES_PASSWORD="$(json '.postgres_password // empty')"
SECRET_KEY_BASE="$(json '.secret_key_base // empty')"

[ -n "$POSTGRES_PASSWORD" ] || die "postgres_password is required"
[ -n "$SECRET_KEY_BASE" ] || die "secret_key_base is required (generate: openssl rand -hex 64)"

# -------- Defaults --------
POSTGRES_USER="$(json '.postgres_user // "sure_user"')"
POSTGRES_DB="$(json '.postgres_db // "sure_production"')"

DB_HOST="$(json '.db_host // "172.30.32.1"')"
DB_PORT="$(json '.db_port // "5432"')"

REDIS_URL="$(json '.redis_url // "redis://redis:6379/1"')"

SELF_HOSTED="$(to_bool_str "$(json '.self_hosted // true')")"
RAILS_FORCE_SSL="$(to_bool_str "$(json '.rails_force_ssl // false')")"
RAILS_ASSUME_SSL="$(to_bool_str "$(json '.rails_assume_ssl // false')")"
ONBOARDING_STATE="$(json '.onboarding_state // "open"')"

OPENAI_ACCESS_TOKEN="$(json '.openai_access_token // empty')"
EXCHANGE_RATE_PROVIDER="$(json '.exchange_rate_provider // empty')"
SECURITIES_PROVIDER="$(json '.securities_provider // empty')"

case "$ONBOARDING_STATE" in
  open|closed|invite_only) ;;
  *) die "onboarding_state must be one of: open, closed, invite_only" ;;
esac

export POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB SECRET_KEY_BASE
export DB_HOST DB_PORT REDIS_URL
export SELF_HOSTED RAILS_FORCE_SSL RAILS_ASSUME_SSL ONBOARDING_STATE
export RAILS_ENV=production RACK_ENV=production
export PORT=3000

[ -n "$OPENAI_ACCESS_TOKEN" ] && export OPENAI_ACCESS_TOKEN
[ -n "$EXCHANGE_RATE_PROVIDER" ] && export EXCHANGE_RATE_PROVIDER
[ -n "$SECURITIES_PROVIDER" ] && export SECURITIES_PROVIDER

# -------- Helpers: wait for deps --------
wait_for_tcp() {
  local host="$1" port="$2" name="$3"
  local max=60 i=1

  log "Waiting for $name at ${host}:${port} ..."
  while [ $i -le $max ]; do
    if ruby -rsocket -e "begin; TCPSocket.new('$host',$port).close; exit 0; rescue; exit 1; end" >/dev/null 2>&1; then
      log "$name is reachable"
      return 0
    fi
    sleep 2
    i=$((i+1))
  done
  die "$name is not reachable after $((max*2))s: ${host}:${port}"
}

parse_redis_host_port() {
  # redis://host:port/db
  local url="$1"
  local rest="${url#redis://}"
  rest="${rest#rediss://}"   # на всякий
  local hostport="${rest%%/*}"
  local host="${hostport%%:*}"
  local port="${hostport##*:}"
  [ -z "$host" ] && host="redis"
  [ "$port" = "$hostport" ] && port="6379"
  echo "$host" "$port"
}

# -------- Storage --------
mkdir -p /data/storage
if [ -e /rails/storage ] && [ ! -L /rails/storage ]; then
  # если есть старый каталог — перенесём содержимое один раз
  if [ -d /rails/storage ] && [ "$(ls -A /rails/storage 2>/dev/null || true)" ]; then
    log "Migrating existing /rails/storage -> /data/storage"
    cp -a /rails/storage/. /data/storage/ || true
  fi
  rm -rf /rails/storage
fi
ln -snf /data/storage /rails/storage

# -------- Wait dependencies --------
wait_for_tcp "$DB_HOST" "$DB_PORT" "Postgres"

read -r REDIS_HOST REDIS_PORT < <(parse_redis_host_port "$REDIS_URL")
wait_for_tcp "$REDIS_HOST" "$REDIS_PORT" "Redis"

# -------- Start --------
log "Starting Sure (web + sidekiq)"
log "DB: ${DB_HOST}:${DB_PORT}  Redis: ${REDIS_URL}"

# db:prepare — ок для первого запуска и для обновлений (idempotent)
./bin/rails db:prepare

bundle exec sidekiq &
SIDEKIQ_PID=$!

./bin/rails server -b 0.0.0.0 -p 3000 &
RAILS_PID=$!

term() {
  log "Stopping..."
  kill -TERM "$RAILS_PID" "$SIDEKIQ_PID" 2>/dev/null || true
  wait "$RAILS_PID" "$SIDEKIQ_PID" 2>/dev/null || true
}
trap term TERM INT

# если один процесс умер — гасим второй и выходим
wait -n "$RAILS_PID" "$SIDEKIQ_PID"
term
exit 1