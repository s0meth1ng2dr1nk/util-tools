#!/usr/bin/env bash
# export PASSWORD='' && URL=https://raw.githubusercontent.com/s0meth1ng2dr1nk/util-tools/main/setup-vm.sh && SCRIPT=$(basename ${URL}) && wget --no-cache ${URL} && chmod u+x ./${SCRIPT} && ./${SCRIPT} && rm -f ./${SCRIPT}
set -eu
sudo bash -c '
    set -eu
    PASSWORD='${PASSWORD}'
    apt update
    apt install -y \
        expect \
        curl \
        git \
        nodejs \
        npm \
        ca-certificates \
        fonts-liberation \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libc6 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libexpat1 \
        libfontconfig1 \
        libgbm1 \
        libgcc1 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libstdc++6 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        lsb-release \
        wget \
        xdg-utils
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    chmod u+x /tmp/get-docker.sh
    (cd /tmp && ./get-docker.sh)
    rm -f /tmp/get-docker.sh
    sed -i -e "/PasswordAuthentication/s/^/#/" -e "/PermitRootLogin/s/^/#/" /etc/ssh/sshd_config
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
    expect -c "
    spawn passwd
    expect \"New password:\"
    send \"${PASSWORD}\n\"
    expect \"Retype new password:\"
    send \"${PASSWORD}\n\"
    expect "
    service sshd restart
'
