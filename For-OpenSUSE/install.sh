!#/bin/bash

# check if we are root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

zypper install -y \
    bash-completion \
    cryptsetup \
    curl \
    dosfstools \
    dracut \
    dracut-tools \
    fuse \
    git \
    jq \
    lsb-release \
    lvm2 \
    nodejs \
    npm \
    parted \
    rsync \
    squashfs \
    sshfs \
    wget \
    xdg-user-dirs \
    xorriso

# Enable uinput
echo "uinput" | tee /etc/modules-load.d/uinput.conf

# Install pnpm
npm i pnpm -g

