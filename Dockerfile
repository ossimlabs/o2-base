# This is a base container to install java and the ossim repo
# there isn't a command to run it is meant to serve as
# a beginning for the rest of the o2 apps
# A base image to install java and the ossim repo.
# There isn't a command to run it is meant to serve as
# a beginning for the rest of the o2 apps.

ARG BASE_IMAGE
FROM ${BASE_IMAGE}
#FROM adoptopenjdk/openjdk8:alpine-slim
USER root
ENV HOME /home/omar
ADD ./yum.repos.d/* /etc/yum.repos.d/
COPY goofys /usr/bin/goofys
RUN yum -y install epel-release && \
    yum clean all && \
    yum -y install java-1.8.0-openjdk && \
    yum -y install haveged && \
    yum -y install wget && \
    yum -y install unzip && \
    yum -y install nss_wrapper gettext fuse fuse-libs libevent curl && \
    yum clean all && \
    yum -y update && \
    yum clean all && \
    chkconfig haveged on && \
    mkdir -p /s3 && chown -R 1001:0 /s3 && chmod 777 /s3 && chmod ugo+x /usr/bin/goofys && \
    echo "user_allow_other" > /etc/fuse.conf && \
    useradd -u 1001 -r -g 0 --create-home -d $HOME -s /sbin/nologin -c 'Default Application User' omar
COPY run.sh $HOME
RUN chown 1001:0 -R $HOME && \
    chmod 777 $HOME && \
    chmod 777 $HOME/*.sh
USER 1001
