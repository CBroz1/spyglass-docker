#!/bin/bash
set -e

# Wait for MySQL to be fully initialized and ready to accept connections
until mysql -e "SELECT 1" &>/dev/null; do
  echo "Waiting for MySQL..."
  sleep 1
done

# Execute all SQL files in the directory
for file in /*.sql; do
  echo "Running $file..."
  # Remove the default charset to avoid collation issues
  sed 's/ DEFAULT CHARSET=[^ ]\w*//g' "$file" > "$file.tmp"
  # Also need to remove the collation? 's/ COLLATE=[^ ]\w*//g' ?
  mysql < "$file.tmp"
done
