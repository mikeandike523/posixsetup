#!/bin/bash

set -e

# just in case

dn="$(dirname "$(realpath "$0")")"
cd "$dn"

# bootstrap python

sudo apt update -y
sudo apt install -y python3-pip
sudo apt install -y python3-venv
sudo apt install -y python3-virtualenv

python3 -m virtualenv pyenv

source pyenv/bin/activate

python3 -m ensurepip --upgrade

pip install pipenv

pipenv install -r requirements.txt

pipenv run python robot.py

deactivate