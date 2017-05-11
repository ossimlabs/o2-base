# OMAR Base

## Dockerfile
```
ROM centos:latest
ADD epel.repo /etc/yum.repos.d/epel.repo
ADD ossim.repo /etc/yum.repos.d/ossim.repo
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm java-1.8.0-openjdk haveged && yum clean all
```
Ref: https://github.com/ossimlabs/omar-base
