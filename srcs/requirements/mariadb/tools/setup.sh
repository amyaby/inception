#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null

    # Start MariaDB in the background temporarily (WITHOUT --skip-networking)
    mysqld --user=mysql --console &
    MYSQL_PID=$!

    # Wait until MariaDB is ready
    echo "Waiting for MariaDB to start..."
    while ! mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    done

    echo "Running setup SQL..."
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # Stop the temporary MariaDB
    kill $MYSQL_PID
    wait $MYSQL_PID

    echo "MariaDB ready ✓"
fi

# Start MariaDB in the foreground (WITHOUT --skip-networking)
echo "Starting MariaDB..."
exec mysqld --user=mysql --console --port=3306 --bind-address=0.0.0.0