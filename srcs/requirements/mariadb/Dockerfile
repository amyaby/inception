FROM alpine:3.18

RUN apk update && apk upgrade && apk add --no-cache \
    mariadb mariadb-client openssl

RUN mkdir -p /var/lib/mysql \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld

COPY conf/my_config.cnf /etc/my.cnf.d/my_config.cnf

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

CMD ["/setup.sh"]