#!/bin/bash
set -e

wait_for_db() {
    max_attempts=30
    attempt=1
    while [ $attempt -le $max_attempts ]; do
        if mysqladmin ping -h db -u"${DB_USER}" -p"${DB_PASSWORD}" --silent > /dev/null 2>&1; then
            return 0
        fi
        attempt=$((attempt + 1))
        sleep 2
    done
    echo "Could not connect to database after $max_attempts attempts"
    return 1
}

mkdir -p /run/php
cd /var/www/html

wait_for_db || exit 1

if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost=db:3306 \
        --allow-root
fi

if ! wp core is-installed --allow-root 2>/dev/null; then
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root
fi

exec php-fpm8.2 -F
