FROM centos:latest
MAINTAINER RadiantBlue Technologies radiantblue.com
RUN yum -y install epel-release && yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm java-1.8.0-openjdk haveged && yum clean all
RUN useradd -u 1001 -r -g 0 -d HOME -s /sbin/nologin -c 'Default Application User' omar && mkdir /home/omar
USER 1001
