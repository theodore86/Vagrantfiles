#!/usr/bin/env bash
set -e

echo "INFO>>> Installing Docker"

apt-get remove \
    docker \
    docker-engine \
    docker.io \
    containerd runc

# Install packages to allow apt to use repository over HTTPS
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

DOWNLOAD_URL='https://download.docker.com/linux/ubuntu'
curl -fsSL --max-time 5 ${DOWNLOAD_URL}/gpg | apt-key add -

add-apt-repository \
    "deb [arch=amd64] ${DOWNLOAD_URL} \
    $(lsb_release -cs) \
    stable"

# Install the latest version of Docker engine - Community
apt-get install -y \
    docker-ce
