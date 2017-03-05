#!/bin/bash

__create_x2gouser() {
# Create a x2gouser to SSH into as.
useradd x2gouser -m
SSH_USERPASS=gogo
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin x2gouser)
echo ssh x2gouser password: $SSH_USERPASS
cd /home/x2gouser
mkdir -p etc/ssh var/run
cp /etc/ssh/sshd_config etc/ssh/sshd_config

sed -i "s/UsePAM.*/UsePAM no/g" etc/ssh/sshd_config && \
sed -i "s/#PermitRootLogin/PermitRootLogin/g" etc/ssh/sshd_config && \
sed -i "s/#Port.*/Port 2022/g" etc/ssh/sshd_config && \
sed -i "s/*.UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" etc/ssh/sshd_config && \
sed -i "s/*.PidFile.*/PidFile \/home\/x2gouser\/var\/run\/sshd.pid/g" etc/ssh/sshd_config && \
sed -i "s/*.HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/home\/x2gouser\/etc\/ssh_host_rsa_key/g" etc/ssh/sshd_config && \
sed -i "s/*.HostKey \/etc\/ssh\/ssh_host_ecdsa_key.*/HostKey \/home\/x2gouser\/etc\/ssh_host_ecdsa_key/g" etc/ssh/sshd_config && \
sed -i "s/*.HostKey \/etc\/ssh\/ssh_host_ed25519_key.*/HostKey \/home\/x2gouser\/etc\/ssh_host_ed25519_key/g" etc/ssh/sshd_config && \
mkdir /var/run/sshd && \
ssh-keygen -t rsa -f /home/x2gouser/etc/ssh/ssh_host_rsa_key -N '' && \
ssh-keygen -t ecdsa -f /home/x2gouser/etc/ssh/ssh_host_ecdsa_key -N '' && \
ssh-keygen -t ed25519 -f /home/x2gouser/etc/ssh/ssh_host_ed25519_key -N '' && \
chown -R x2gouser: /home/x2gouser/
yum clean all



}

# Generate passwd file based on current uid
function generate_passwd_file() {
HOME=/home/x2gouser
  export USER_ID=$(id -u)
  export GROUP_ID=$(id -g)
  grep -v ^x2gouser /etc/passwd > "$HOME/passwd"
  echo "x2gouser:x:${USER_ID}:${GROUP_ID}:X2go x2gouser:${HOME}:/bin/bash" >> "$HOME/passwd"
  export LD_PRELOAD=libnss_wrapper.so
  export NSS_WRAPPER_PASSWD=${HOME}/passwd
  export NSS_WRAPPER_GROUP=/etc/group
}

# Call all functions
__create_x2gouser
generate_passwd_file
