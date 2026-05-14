FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/^bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/mymariadbconf.conf
COPY tools/mariadbrun.sh /usr/local/bin/mariadbrun.sh

RUN chmod +x /usr/local/bin/mariadbrun.sh

CMD ["/usr/local/bin/mariadbrun.sh"]
