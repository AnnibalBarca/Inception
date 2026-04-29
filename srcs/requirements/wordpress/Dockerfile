FROM debian:12-slim

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    mariadb-client \
    wget \
    && wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www \
    && cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz \
    && wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && apt-get clean

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wordpressrun.sh /usr/local/bin/wordpressrun.sh

RUN chmod +x /usr/local/bin/wordpressrun.sh

CMD ["/usr/local/bin/wordpressrun.sh"]
