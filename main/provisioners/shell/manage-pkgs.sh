#!/usr/bin/env bash
set -e

echo "INFO>>> Removing unwanted default distro packages"

apt-get remove -y \
    vim-tiny

echo "INFO>>> Installing development packages"

apt-get install -y \
    build-essential \
    software-properties-common \
    language-pack-en \
    git-core \
    zip unzip \
    vim \
    ack-grep \
    python-pip \
    deborphan \
    tree \
    lynx \
    bash-completion \
    libldap-2.4.2 ldap-utils \
    python-tk python3-tk \
    graphviz \
    xauth \
    dos2unix \
    lsyncd
