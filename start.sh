#!/bin/bash

__create_user() {
# Create a user to SSH into as.
useradd user -m
SSH_USERPASS=newpass
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin user)
echo ssh user password: $SSH_USERPASS
cd /home/user
mkdir -p etc/ssh var/run
cp /etc/ssh/sshd_config etc/ssh/sshd_config

sed -i "s/UsePAM.*/UsePAM no/g" etc/ssh/sshd_config && \
sed -i "s/#PermitRootLogin/PermitRootLogin/g" etc/ssh/sshd_config && \
sed -i "s/#Port.*/Port 2022/g" etc/ssh/sshd_config && \
sed -i "s/*.UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" etc/ssh/sshd_config && \
sed -i "s/*.PidFile.*/PidFile \/home\/user\/var\/run\/sshd.pid/g" etc/ssh/sshd_config && \
sed -i "s/*.HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/home\/user\/etc\/ssh_host_rsa_key/g" etc/ssh/sshd_config && \
sed -i "s/*.HostKey \/etc\/ssh\/ssh_host_ecdsa_key.*/HostKey \/home\/user\/etc\/ssh_host_ecdsa_key/g" etc/ssh/sshd_config && \
sed -i "s/*.HostKey \/etc\/ssh\/ssh_host_ed25519_key.*/HostKey \/home\/user\/etc\/ssh_host_ed25519_key/g" etc/ssh/sshd_config && \
mkdir /var/run/sshd && \
ssh-keygen -t rsa -f /home/user/etc/ssh/ssh_host_rsa_key -N '' && \
ssh-keygen -t ecdsa -f /home/user/etc/ssh/ssh_host_ecdsa_key -N '' && \
ssh-keygen -t ed25519 -f /home/user/etc/ssh/ssh_host_ed25519_key -N '' && \
chown -R user: /home/user/
yum clean all
}

# Call all functions
__create_user
