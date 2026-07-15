#!/bin/bash
set -e

# Start MySQL initialization script in the background
/usr/local/bin/init-mysql.sh &

# Wait a moment for MySQL to begin initializing
sleep 5

# Wait until MySQL is reachable on localhost
until nc -z localhost 3306; do
    echo "Waiting for MySQL to accept connections..."
    sleep 2
done

# Give MySQL a bit more time to finish schema/data load
sleep 3

# Start Tomcat in the foreground
exec /usr/local/tomcat/bin/catalina.sh run
