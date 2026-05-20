FROM alpine:3.18

RUN apk update && apk upgrade && apk add --no-cache \
    php82            \
    php82-fpm        \
    php82-mysqli     \
    php82-json       \
    php82-curl       \
    php82-dom        \
    php82-mbstring   \
    php82-openssl    \
    php82-xml        \
    php82-phar       \
    php82-session    \
    php82-tokenizer  \
    php82-fileinfo   \
    php82-iconv      \
    php82-zip        \
    wget             \
    curl             \
    bash             \
    mysql-client     \
    ca-certificates

RUN ln -s /usr/bin/php82 /usr/bin/php

RUN echo "memory_limit=256M" > /etc/php82/conf.d/memory.ini

COPY wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html \
    && chown -R nobody:nobody /var/www/html

COPY conf/www.conf /etc/php82/php-fpm.d/www.conf
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000
CMD ["/setup.sh"]