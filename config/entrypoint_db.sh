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
  if mysqladmin ping -p"$MYSQL_PASSWORD" --silent; then
    break
  fi
  echo "Waiting for MySQL ... $i"
  sleep 1
  if [ "$i" -eq 0 ]; then
    echo "MySQL failed to start"
    exit 1
  fi
done

# Execute all SQL scripts in the initialization directory
for f in /docker-entrypoint-initdb.d/*.sql; do
  echo "Running $f..."
  mysql -u"$MYSQL_USER" -p"$MYSQL_ROOT_PASSWORD" < "$f"
done

# Wait for the original entrypoint script to finish
wait
