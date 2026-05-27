#!/bin/bash

# Author: Chris Brozdowski
# Date: 2024-07-29
# Script Name: entrypoint_db.sh
# Description: This script is run by the database instance to
#   (a) run the original entrypoint script from the image in the background,
#   (b) wait for MySQL to be ready, and
#   (c) execute all SQL scripts in the initialization directory.

# Exit immediately if a command exits with a non-zero status
set -e

# Run the original entrypoint script from the image
/entrypoint.sh mysqld &

# Wait for MySQL to be ready
for i in {30..0}; do # 30 second timeout
  if mysqladmin ping -p"$MYSQL_ROOT_PASSWORD" --silent; then
    break
  fi
  echo "Waiting for MySQL ... $i"
  sleep 1
  if [ "$i" -eq 0 ]; then
    echo "MySQL failed to start"
    exit 1
  fi
done

# Grant remote root access using env-provided credentials
mysql -u"$MYSQL_USER" -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'${MYSQL_ROOT_HOST}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'${MYSQL_ROOT_HOST}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Execute all SQL scripts in the initialization directory
for f in /docker-entrypoint-initdb.d/*.sql; do
  echo "Running $f..."
  mysql -u"$MYSQL_USER" -p"$MYSQL_ROOT_PASSWORD" < "$f"
done

# Wait for the original entrypoint script to finish
wait
