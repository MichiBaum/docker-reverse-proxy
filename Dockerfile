FROM nginx:1.25.3
LABEL version="1.0"
LABEL maintainer="Michael Baumberger"

# Remove default shit
RUN rm /etc/nginx/conf.d/default.conf && \
    rm /etc/nginx/nginx.conf && \
    rm -f /var/log/nginx/* && \
    rm -r /usr/share/nginx/html

#Update and install everything
RUN apt-get update && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y apache2-utils && \
    apt-get -y install libncursesw5-dev gcc make && \
    apt-get -y install libncursesw5-dev libgeoip-dev libmaxminddb-dev && \
    apt-get install -y inotify-tools certbot openssl && \
    apt-get install -y cron && \
    apt-get install -y wget && \
    apt-get update && \
    apt-get clean  && \
    apt-get autoclean && \
    apt-get autoremove && \
    apt-get --purge autoremove

#Copy all neccessary files from host to docker
COPY ./robots.txt /etc/nginx/robots.txt
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./entrypoint.sh /opt/nginx-letsencrypt/entrypoint.sh
COPY ./certbot.sh /opt/certbot.sh
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./ssl-options/options-nginx-ssl.conf /etc/ssl-options/options-nginx-ssl.conf

#Run ssl configuration
RUN openssl dhparam -out /etc/ssl-options/ssl-dhparams.pem 2048
RUN chmod +x /opt/nginx-letsencrypt/entrypoint.sh && \
    chmod +x /opt/certbot.sh

CMD /opt/nginx-letsencrypt/entrypoint.sh