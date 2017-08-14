# OMAR Base

## Dockerfile
```
FROM rhel-minimal:latest
USER root
ENV HOME /home/omar
ADD ossim.repo /etc/yum.repos.d/ossim.repo
ADD epel.repo /etc/yum.repos.d/epel.repo
ADD rhel.repo /etc/yum.repos.d/rhel.repo
RUN subscription-manager config --rhsm.manage_repos=0
RUN yum -y install epel-release
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install java-1.8.0-openjdk
RUN yum -y install haveged
RUN yum -y install wget
RUN yum -y install unzip
RUN yum clean all
RUN useradd -u 1001 -r -g 0 --create-home -d $HOME -s /sbin/nologin -c 'Default Application User' omar
USER 1001
```
Ref: [rhel-minimal](../../../rhel-minimal/docs/install-guide/rhel-minimal/)
Ref: [https://github.com/ossimlabs/omar-base](https://github.com/ossimlabs/omar-base)

If the docker file is created then:

`docker build -t omar-base:latest .`

Push that to your registry and this is used as a base image for all omar services that do not require the ossim core JNI interfaces.
