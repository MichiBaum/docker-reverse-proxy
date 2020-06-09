FROM nginx:1.17.10 AS BUILD

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf
RUN rm /etc/nginx/meme.types
RUN rm -f /var/log/nginx/*

COPY ./lifemanagement.conf /etc/nginx/conf.d/lifemanagement.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./meme.types /etc/nginx/meme.types

RUN rm -r /usr/share/nginx/html