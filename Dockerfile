FROM nginx:1.17.10

RUN rm /etc/nginx/conf.d/default.conf && \
    rm /etc/nginx/nginx.conf && \
    rm -f /var/log/nginx/* && \
    rm -r /usr/share/nginx/html

COPY ./robots.txt /etc/nginx/robots.txt
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN apt-get update && \
    apt-get update

RUN apt-get install -y inotify-tools certbot openssl
WORKDIR /opt
COPY ./entrypoint.sh nginx-letsencrypt
COPY ./certbot.sh certbot.sh
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./ssl-options/ /etc/ssl-options
RUN chmod +x nginx-letsencrypt && \
    chmod +x certbot.sh 
ENTRYPOINT ["./nginx-letsencrypt"]