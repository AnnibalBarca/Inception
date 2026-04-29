FROM debian:12-slim

RUN apt update --no-install-recommends -y && \
    apt upgrade -y && \
    apt-get install -y mariadb-server

COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/mymariadbconf.conf
COPY tools/mariadbrun.sh /usr/local/bin/mariadbrun.sh

RUN chmod +x /usr/local/bin/mariadbrun.sh

CMD ["/usr/local/bin/mariadbrun.sh"]
