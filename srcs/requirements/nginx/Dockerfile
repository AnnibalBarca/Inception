FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends nginx openssl ca-certificates procps && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
        -out /etc/nginx/ssl/inception.crt \
        -keyout /etc/nginx/ssl/inception.key \
        -subj "/CN=almeekel.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
