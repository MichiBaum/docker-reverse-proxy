FROM nginx:1.17.10

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf
RUN rm -f /var/log/nginx/*

COPY ./robots.txt /etc/nginx/robots.txt
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN rm -r /usr/share/nginx/html

RUN apt-get update && \
    apt-get update

RUN apk add inotify-tools certbot openssl
WORKDIR /opt
COPY entrypoint.sh nginx-letsencrypt
COPY certbot.sh certbot.sh
COPY default.conf /etc/nginx/conf.d/default.conf
COPY ssl-options/ /etc/ssl-options
RUN chmod +x nginx-letsencrypt && \
    chmod +x certbot.sh 
ENTRYPOINT ["./nginx-letsencrypt"]