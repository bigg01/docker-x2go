FROM centos:centos7

MAINTAINER o.guggenbuehl@gmail.com

RUN yum install -y  --setopt=tsflags=nodocs \
    http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm  \
    x2goserver-xsession openssh-server x2goserver x2goserver-xsession \
    x2golxdebindings pwgen firefox pulseaudio libcurl3 \
    terminator nss_wrapper gettext

RUN yum -y groupinstall Xfce --setopt=tsflags=nodocs 

## fix the locale crap 
#RUN yum -y reinstall glibc-common

ADD ./start.sh /start.sh

RUN chmod +x /start.sh && ./start.sh
ADD ./sshd_config /home/user/etc/ssh/sshd_config
EXPOSE 2022

USER x2gouser
ENV LD_PRELOAD libnss_wrapper.so
ENV NSS_WRAPPER_PASSWD /home/x2gouser/passwd
ENV NSS_WRAPPER_GROUP /etc/group
CMD    ["/usr/sbin/sshd", "-f", "/home/user/etc/ssh/sshd_config", "-D", "-d"]
