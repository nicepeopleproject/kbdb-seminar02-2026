#!/usr/bin/env bash
# Простейший мигратор: применяет V<N>__<name>.sql по возрастанию N,
# запоминает применённые в project.schema_migration, повторно не применяет.
# Учебный аналог Flyway — чтобы было видно, как это устроено внутри.
set -euo pipefail
DIR="${1:-seminar02/migrations}"
PSQL="${PSQL:-docker compose exec -T postgres psql -U student -d plant -v ON_ERROR_STOP=1 -q}"

$PSQL -c "create schema if not exists project;
          create table if not exists project.schema_migration (
            version int primary key, name text not null, applied_at timestamptz not null default now());"

for f in $(ls "$DIR"/V*__*.sql 2>/dev/null | sort -V); do
  base=$(basename "$f" .sql)
  ver=${base#V}; ver=${ver%%__*}
  name=${base#*__}
  applied=$($PSQL -tA -c "select 1 from project.schema_migration where version = $ver")
  if [ "$applied" = "1" ]; then
    echo "  = V$ver $name (уже применена)"
    continue
  fi
  echo "  + V$ver $name"
  ( echo "begin;"; cat "$f"; echo "insert into project.schema_migration(version, name) values ($ver, '$name'); commit;" ) | $PSQL
done
echo "done."
