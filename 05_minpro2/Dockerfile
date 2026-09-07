FROM quay.io/centos/centos:9

RUN yum -y -q install \
        httpd php php-fpm php-cli php-common php-mysqlnd php-opcache \
    && yum clean all

VOLUME ["/var/www/html", "/var/log/httpd"]
ADD src.tar /var/www/html
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
