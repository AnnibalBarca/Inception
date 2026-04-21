FROM debian:12-slim 

ENV DEBIAN_FRONTEND=noninteractive
#a revoir

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends nginx openssl ca-certificates procps && \
    rm -rf /var/lib/apt/lists/*


RUN chmod +x /usr/local/bin/entrypoint.sh
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes 
    -out /etc/nginx/ssl/inception.crt 
    -keyout /etc/nginx/ssl/inception.key 
    -subj "CN=almeekel.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh


EXPOSE 443
#inutile si docker compose la
STOPSIGNAL SIGTERM
#idem

#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#revoir
CMD ["nginx", "-g", "daemon off;"]