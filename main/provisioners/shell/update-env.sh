#!/usr/bin/env bash
set -e

echo "INFO>>> Updating System"

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" upgrade
apt-get -y dist-upgrade
apt-get autoclean
apt-get clean
apt-get autoremove
