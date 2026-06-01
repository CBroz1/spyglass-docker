#!/bin/bash

# Author: Chris Brozdowski (original), with later modifications
# Description:
#   (a) run the original entrypoint script from the image in the background,
#   (b) wait for MySQL to be ready, and
#   (c) on subsequent restarts (existing data dir), ensure the configured
#       remote-root user exists and re-run the init SQL files.
#
#   On a fresh init (empty /var/lib/mysql), the official mysql entrypoint
#   handles user setup and SQL imports itself via /docker-entrypoint-initdb.d/;
#   we skip our parallel run to avoid races where the dump alters root@localhost
#   auth mid-run.

set -e

# Detect whether the data dir is empty BEFORE /entrypoint.sh runs.
NEEDS_INIT=0
if [ ! -d /var/lib/mysql/mysql ]; then
    NEEDS_INIT=1
fi

# Run the original entrypoint script from the image
/entrypoint.sh mysqld &

# Wait for MySQL to be ready (socket ping, no auth required)
for i in {60..0}; do
  if mysqladmin ping -h localhost -S /var/run/mysqld/mysqld.sock --silent 2>/dev/null; then
    break
  fi
  echo "Waiting for MySQL ... $i"
  sleep 1
  if [ "$i" -eq 0 ]; then
    echo "MySQL failed to start"
    exit 1
  fi
done

if [ "$NEEDS_INIT" -eq 1 ]; then
    echo "Fresh init: official entrypoint is handling users + SQL imports."
else
    echo "Existing data dir: ensuring ${MYSQL_USER}@'${MYSQL_ROOT_HOST}' and re-running SQL imports..."

    mysql -h localhost -S /var/run/mysqld/mysqld.sock -uroot <<EOF || true
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'${MYSQL_ROOT_HOST}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
ALTER USER '${MYSQL_USER}'@'${MYSQL_ROOT_HOST}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'${MYSQL_ROOT_HOST}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

    for f in /docker-entrypoint-initdb.d/*.sql; do
      echo "Running $f..."
      mysql -h localhost -S /var/run/mysqld/mysqld.sock -uroot < "$f" || true
    done
fi

# Wait for the original entrypoint script to finish
wait
