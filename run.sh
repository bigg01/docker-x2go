#!/bin/bash

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
/usr/sbin/sshd -f /home/x2gouser/etc/ssh/sshd_config -D -d
