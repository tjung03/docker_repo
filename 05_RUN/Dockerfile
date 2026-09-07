FROM ubuntu:24.04

RUN apt -y update && apt -y upgrade
RUN apt -y install nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
