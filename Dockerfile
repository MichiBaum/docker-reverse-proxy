FROM nginx:1.17.10

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf
RUN rm -f /var/log/nginx/*

COPY ./michibaum.ch.conf /etc/nginx/conf.d/michibaum.ch.conf
COPY ./robots.txt /etc/nginx/robots.txt
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN rm -r /usr/share/nginx/html

RUN apt-get update && \
    apt-get update && \
    apt-get --assume-yes install python-certbot-nginx && \
    certbot --nginx --email michael_baumberger@gmx.ch --agree-tos --no-eff-email --staging -d michibaum.ch