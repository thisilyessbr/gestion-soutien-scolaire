#!/bin/bash
set -e

# Initialize MySQL data directory if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MySQL data directory..."
    mysqld --initialize-insecure --user=mysql
fi

# Start MySQL in the background
mysqld --user=mysql &
MYSQL_PID=$!

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
for i in {1..60}; do
    if mysqladmin ping --silent; then
        echo "MySQL is ready!"
        break
    fi
    sleep 1
done

# Check if MySQL started
if ! mysqladmin ping --silent; then
    echo "MySQL failed to start"
    exit 1
fi

# Create root user and application user/database
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Run schema and data scripts
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" "${DB_NAME}" < /docker-entrypoint-initdb.d/01-schema.sql
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" "${DB_NAME}" < /docker-entrypoint-initdb.d/02-data.sql

echo "Database initialized successfully!"

# Keep MySQL running in the background
wait $MYSQL_PID
