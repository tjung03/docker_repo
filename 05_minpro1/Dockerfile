FROM quay.io/centos/centos:stream9

RUN dnf -y install vsftpd && dnf clean all

COPY vsftpd.conf.template /etc/vsftpd/vsftpd.conf

VOLUME /var/ftp/pub
COPY WelcomeToMyFTPServer.txt /var/ftp/pub/

EXPOSE 21 20

ENTRYPOINT ["/usr/sbin/vsftpd"]

