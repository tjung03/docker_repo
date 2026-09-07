FROM quay.io/centos/centos:stream9

# useradd user01
RUN ["/usr/sbin/useradd", "user01"]
RUN ["whoami"]
RUN ["id"]

# su - user01
USER user01
RUN ["whoami"]
RUN ["id"]
