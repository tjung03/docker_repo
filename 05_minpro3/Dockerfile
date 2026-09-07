FROM quay.io/centos/centos:9

RUN dnf -y install httpd mod_wsgi && dnf clean all
COPY vhost.conf /etc/httpd/conf.d
COPY myapp.wsgi /var/www/html

EXPOSE 80/tcp

# /usr/sbin/httpd -D FOREGROUND
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
