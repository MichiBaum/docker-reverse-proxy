FROM nginx:1.17.10

RUN rm /etc/nginx/conf.d/default.conf && \
    rm /etc/nginx/nginx.conf && \
    rm -f /var/log/nginx/* && \
    rm -r /usr/share/nginx/html

COPY ./robots.txt /etc/nginx/robots.txt
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN apt-get update && \
    apt-get update && \
    apt-get install apache2-utils
    
RUN apt-get install -y inotify-tools certbot openssl
COPY ./entrypoint.sh /opt/nginx-letsencrypt/entrypoint.sh
COPY ./certbot.sh /opt/certbot.sh
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./ssl-options/options-nginx-ssl.conf /etc/ssl-options/options-nginx-ssl.conf
RUN openssl dhparam -out /etc/ssl-options/ssl-dhparams.pem 2048
RUN chmod +x /opt/nginx-letsencrypt/entrypoint.sh && \
    chmod +x /opt/certbot.sh

# TODO create random password
RUN htpasswd -B -C 10 -i -c /var/www/goaccess/.htpasswd admin admin

ENTRYPOINT ["/opt/nginx-letsencrypt/entrypoint.sh"]