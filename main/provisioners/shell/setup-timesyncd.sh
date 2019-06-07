#!/usr/bin/env bash
set -e

TIMEZONE=${1-:UTC}

echo "INFO>>> Setting TimeZone to $TIMEZONE"
timedatectl set-timezone $TIMEZONE

echo "INFO>>> Disabling TimeSyncd service"
timedatectl set-ntp off
systemctl stop systemd-timesyncd.service
systemctl status systemd-timesyncd.service || true
