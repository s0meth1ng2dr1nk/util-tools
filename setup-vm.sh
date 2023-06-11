#!/usr/bin/env bash
# export PASSWORD='' && apt update && apt install -y wget && wget https://raw.githubusercontent.com/s0meth1ng2dr1nk/util-tools/main/setup-vm.sh && chmod u+x ./setup-vm.sh && ./setup-vm.sh && rm -f ./setup-vm.sh
set -eu
sudo bash -c '
    PASSWORD='${PASSWORD}' && \
    PORT=18022 && \
    apt update && apt install -y expect curl git && \
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh && \
    chmod u+x /tmp/get-docker.sh && \
    (cd /tmp && ./get-docker.sh) && \
    rm -f /tmp/get-docker.sh && \
    sed -i -e "/PasswordAuthentication/s/^/#/" -e "/PermitRootLogin/s/^/#/" -e "/Port/s/^/#/" /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "Port ${PORT}" >> && \ 
    expect -c "
    spawn passwd
    expect \"New password:\"
    send \"${PASSWORD}\n\"
    expect \"Retype new password:\"
    send \"${PASSWORD}\n\"
    expect " && \
    service sshd restart
'
