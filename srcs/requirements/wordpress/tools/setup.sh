#!/bin/bash

export WP_CLI_PHP_ARGS="-d memory_limit=256M"

echo "Waiting for MariaDB..."
while ! mysql -h mariadb \
              -u "${MYSQL_USER}" \
              -p"${MYSQL_PASSWORD}" \
              -e "SELECT 1;" > /dev/null 2>&1; do
    echo "MariaDB not ready yet, waiting..."
    sleep 2
done
echo "MariaDB is ready ✓"

cd /var/www/html
if [ ! -f wp-config.php ]; then

    echo "Downloading WordPress..."
    wp core download \
        --allow-root \
        --locale=en_US

    echo "Creating wp-config.php..."
    wp config create \
        --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb" \
        --url="https://${DOMAIN_NAME}"

    echo "Installing WordPress..."
    wp core install \
        --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email

    echo "Creating second user..."
    wp user create \
        --allow-root \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}"

    echo "WordPress installed ✓"
fi

echo "Starting php-fpm..."
exec php-fpm82 -F