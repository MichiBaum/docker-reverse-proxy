FROM nginx:1.19.0 AS BUILD

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf
RUN rm -f /var/log/nginx/*

RUN mkdir -p /etc/letsencrypt/live/michibaum.ch/

COPY ./options-ssl-nginx.conf /etc/letsencrypt/options-ssl-nginx.conf
COPY ./ssl-dhparams.pem /etc/letsencrypt/ssl-dhparams.pem

COPY ./lifemanagement.conf /etc/nginx/conf.d/lifemanagement.conf
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN rm -r /usr/share/nginx/html