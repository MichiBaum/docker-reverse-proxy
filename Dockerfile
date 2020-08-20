FROM nginx:1.17.10

RUN rm /etc/nginx/conf.d/default.conf && \
    rm /etc/nginx/nginx.conf && \
    rm -f /var/log/nginx/* && \
    rm -r /usr/share/nginx/html

COPY ./robots.txt /etc/nginx/robots.txt
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN apt-get update && \
    apt-get update && \
    apt-get install -y apache2-utils && \
    apt-get install -y goaccess && \
    apt-get install -y inotify-tools certbot openssl && \
    apt-get install -y cron && \
    apt-get update && \
    apt-get clean  && \
    apt-get autoclean && \
    apt-get autoremove && \
    apt-get --purge autoremove
    
COPY ./entrypoint.sh /opt/nginx-letsencrypt/entrypoint.sh
COPY ./certbot.sh /opt/certbot.sh
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./ssl-options/options-nginx-ssl.conf /etc/ssl-options/options-nginx-ssl.conf
RUN openssl dhparam -out /etc/ssl-options/ssl-dhparams.pem 2048
RUN chmod +x /opt/nginx-letsencrypt/entrypoint.sh && \
    chmod +x /opt/certbot.sh

# TODO change goaccess config
RUN mkdir -p /var/www/goaccess/
# TODO create random password
RUN htpasswd -b -c /var/www/goaccess/.htpasswd admin admin

COPY ./cronjobs/goaccess /etc/cron.d/goaccess

ENTRYPOINT ["/opt/nginx-letsencrypt/entrypoint.sh"]