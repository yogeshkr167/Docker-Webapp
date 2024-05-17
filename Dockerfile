FROM centos:7
ENV user=ubuntu
RUN yum install httpd -y
COPY index.html /var/www/html/
