FROM nginx:1.17.10

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf
RUN rm -f /var/log/nginx/*

RUN apt-get update

COPY ./proxy.conf /etc/nginx/conf.d/proxy.conf
COPY ./robots.txt /etc/nginx/robots.txt
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN rm -r /usr/share/nginx/html