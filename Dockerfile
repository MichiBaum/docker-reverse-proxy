FROM nginx:1.17.10

RUN rm /etc/nginx/conf.d/default.conf && \
    rm /etc/nginx/nginx.conf && \
    rm -f /var/log/nginx/* && \
    rm -r /usr/share/nginx/html

COPY ./robots.txt /etc/nginx/robots.txt
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN apt-get install nginx-module-geoip && \
    apt-get update && \
    apt-get update

RUN apt-get install -y inotify-tools certbot openssl
COPY ./entrypoint.sh /opt/nginx-letsencrypt/entrypoint.sh
COPY ./certbot.sh /opt/certbot.sh
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./ssl-options/options-nginx-ssl.conf /etc/ssl-options/options-nginx-ssl.conf
COPY ./ssl-options/ssl-dhparams.pem /etc/ssl-options/ssl-dhparams.pem
RUN chmod +x /opt/nginx-letsencrypt/entrypoint.sh && \
    chmod +x /opt/certbot.sh
ENTRYPOINT ["/opt/nginx-letsencrypt/entrypoint.sh"]