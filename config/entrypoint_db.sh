#!/bin/bash
set -e

# Run the original entrypoint script from the image
/entrypoint.sh mysqld &

# Wait for MySQL to be ready
for i in {30..0}; do # For loop waiting for MySQL to be ready
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
