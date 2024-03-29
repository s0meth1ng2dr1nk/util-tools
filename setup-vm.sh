#!/usr/bin/env bash
# export PASSWORD='' && URL=https://raw.githubusercontent.com/s0meth1ng2dr1nk/util-tools/main/setup-vm.sh && SCRIPT=$(basename ${URL}) && wget --no-cache ${URL} && chmod u+x ./${SCRIPT} && ./${SCRIPT} && rm -f ./${SCRIPT}
set -eu
sudo bash -c '
    PASSWORD='${PASSWORD}' && \
    apt update && apt install -y expect curl git && \
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh && \
    chmod u+x /tmp/get-docker.sh && \
    (cd /tmp && ./get-docker.sh) && \
    rm -f /tmp/get-docker.sh && \
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
