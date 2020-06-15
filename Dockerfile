FROM nginx:1.19.0 AS BUILD

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf
RUN rm -f /var/log/nginx/*

RUN apt-get update && \
    apt-get install -y openssl && \
    mkdir -p /ssl/cer && \
    openssl genrsa -des3 -passout pass:kjdsisi -out /ssl/cer/server.pass.key 2048 && \
    openssl rsa -passin pass:kjdsisi -in /ssl/cer/server.pass.key -out /ssl/cer/server.key && \
    rm /ssl/cer/server.pass.key && \
    openssl req -new -key /ssl/cer/server.key -out /ssl/cer/server.csr \
        -subj "/C=CH/ST=Graubuenden/L=Chur/O='.'/OU='.' Department/CN=michibaum.ch" && \
    openssl x509 -req -days 365 -in /ssl/cer/server.csr -signkey /ssl/cer/server.key -out /ssl/cer/server.crt

COPY ./lifemanagement.conf /etc/nginx/conf.d/lifemanagement.conf
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN rm -r /usr/share/nginx/html