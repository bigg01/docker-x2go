FROM centos:centos7

MAINTAINER o.guggenbuehl@gmail.com

RUN yum install -y  \
    http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm  \
    x2goserver-xsession openssh-server x2goserver x2goserver-xsession x2golxdebindings pwgen firefox pulseaudio libcurl3

RUN yum -y groupinstall Xfce

## fix the locale crap 
#RUN yum -y reinstall glibc-common

ADD ./start.sh /start.sh

RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \
    sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config && \
    mkdir /var/run/sshd && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \ 
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' && \

RUN chmod +x /start.sh && ./start.sh
EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
