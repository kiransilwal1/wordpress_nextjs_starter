#!/bin/bash
set -e

echo "Checking if database '$WORDPRESS_DB_NAME' exists in $WORDPRESS_DB_HOST..."

# Wait for MySQL to be ready
until mysql -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
  echo "Waiting for MySQL..."
  sleep 3
done

# Create the database if it doesn't exist
mysql -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$WORDPRESS_DB_NAME\`;"

echo "Database check complete."

# Start the original WordPress entrypoint
exec docker-entrypoint.sh apache2-foreground
