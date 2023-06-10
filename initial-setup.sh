#!/usr/bin/env bash
set -eu
sudo bash -c '
    apt update && apt install expect curl git -y
    
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh && \
    chmod u+x /tmp/get-docker.sh && \
    (cd /tmp && ./get-docker.sh) && \
    rm -f /tmp/get-docker.sh
    
    PASSWORD=rootroot && \
    sed -i -e "/PasswordAuthentication/s/^/#/" -e "/PermitRootLogin/s/^/#/" /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    expect -c "
    spawn passwd
    expect \"New password:\"
    send \"${PASSWORD}\n\"
    expect \"Retype new password:\"
    send \"${PASSWORD}\n\"
    expect " && \
    service sshd restart
'