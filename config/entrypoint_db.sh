#!/bin/bash
set -e

# Run the original entrypoint script from the image
# /docker-entrypoint.sh mysqld &

CREDS="-u$MYSQL_USER -p$MYSQL_PASSWORD"

# # Wait for MySQL to be ready
# count=0
# max=10
# until mysql "$CREDS" -e "SELECT 1;" &>/dev/null; do
#   if [ $count -eq $max ]; then
#     echo "Error: Couldn't connect to MySQL."
#     exit 1
#   fi
#   echo "Waiting for MySQL ... $count"
#   echo $CREDS
#   (( count++ ))
#   sleep 1
# done

# Execute all SQL scripts in the initialization directory
for f in /docker-entrypoint-initdb.d/*.sql; do
  echo "Running $f..."
  mysql "$CREDS" < "$f"
done

# Wait for the original entrypoint script to finish
# wait
