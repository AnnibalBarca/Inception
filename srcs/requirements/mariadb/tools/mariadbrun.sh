#!/bin/bash
set -e

install -d -m 755 -o mysql /run/mysqld

if [ ! -f "/var/lib/mysql/.initialized" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db > /dev/null

    mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    MYSQL_PID=$!

    i=0
    until mysqladmin --socket=/run/mysqld/mysqld.sock ping --silent 2>/dev/null; do
        sleep 1
        i=$((i + 1))
        if [ $i -ge 30 ]; then
            echo "MariaDB did not start in time"
            kill "$MYSQL_PID" 2>/dev/null
            exit 1
        fi
    done

    mysql --socket=/run/mysqld/mysqld.sock -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT_PASSWORD}');
FLUSH PRIVILEGES;
EOF

    touch /var/lib/mysql/.initialized
    kill "$MYSQL_PID"
    wait "$MYSQL_PID" 2>/dev/null || true
fi

exec mysqld_safe
