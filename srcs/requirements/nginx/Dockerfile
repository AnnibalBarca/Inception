FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends nginx openssl ca-certificates procps && \
    rm -rf /var/lib/apt/lists/*

# COPY nginx.conf /etc/nginx/nginx.conf
# COPY conf.d/default.conf /etc/nginx/conf.d/default.conf
# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
    mkdir -p /etc/nginx/ssl
    openssl req 

EXPOSE 443
STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]