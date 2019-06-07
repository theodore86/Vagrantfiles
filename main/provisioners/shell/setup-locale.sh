#!/usr/bin/env bash
set -e

LOCALE=${1-:en_US}
echo "INFO>>> Setting up Locale to $LOCALE"

locale-gen $LOCALE
update-locale LANG=$LOCALE.UTF-8 LC_CTYPE=$LOCALE.UTF-8
