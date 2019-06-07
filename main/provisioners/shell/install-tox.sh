#!/usr/bin/env bash
set -e

echo "INFO>>> Installing Tox automation project"

python -m pip --version
python -m pip install --user tox
python -m tox --version
