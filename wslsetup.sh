#!/bin/bash

# Exit on error
set -xe

# Update and upgrade the package list
sudo apt-get update -y
sudo apt-get upgrade -y

# Install python3 dependencies, python3.12 and python3.12 dependencies
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update -y
sudo apt install -y  python3.12 python3.12-venv
sudo apt install -y python3-pip python3-venv python3-virtualenv

# Install software-properties-common for adding repositories
sudo apt-get -y install software-properties-common

# Install Node.js and npm
# Using NodeSource's binary distributions
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo npm install -g npm@latest

# Verify the installation of Node.js and npm
node --version
npm --version

# Install Yarn globally using npm
sudo npm install --global yarn

# Verify Yarn installation
yarn --version

# Install docker and docker-compose
# credit https://support.netfoundry.io/hc/en-us/articles/360057865692-Installing-Docker-and-docker-compose-for-Ubuntu-20-04
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update -y
sudo apt install -y docker-ce
sudo usermod -aG docker ${USER}
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker --version
docker-compose --version

# Setup the folders recommended for single-user software installation
# We use single-user installation since we dont want to be forced to run it as sudo
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/bin"


cd "$HOME/.local/share"
rm -rf gitsleuth
rm -rf tsleuth
rm -rf eolinuxify

# Install custom tool "gitsleuth"
cd "$HOME/.local/share"
git clone https://github.com/mikeandike523/gitsleuth
cd gitsleuth
python3.12 -m venv pyenv
source pyenv/bin/activate
pip install -r requirements.txt
deactivate
rm -f "$HOME/.local/bin/gitsleuth"
ln -s "$HOME/.local/share/gitsleuth/gitsleuth" "$HOME/.local/bin/gitsleuth"

# Install custom tool "tsleuth"
cd "$HOME/.local/share"
git clone https://github.com/mikeandike523/tsleuth
cd tsleuth
yarn install
yarn run build-all
rm -f "$HOME/.local/bin/tsleuth"
ln -s "$HOME/.local/share/tsleuth/tsleuth" "$HOME/.local/bin/tsleuth"

# Install custom tool "eolinuxify"
cd "$HOME/.local/share"
git clone https://github.com/mikeandike523/eolinuxify
cd eolinuxify
sudo chmod +x ./configure
./configure
rm -f "$HOME/.local/bin/eolinuxify"
ln -s "$HOME/.local/share/eolinuxify/eolinuxify" "$HOME/.local/bin/eolinuxify"

# test installations
gitsleuth --help
tsleuth --help
eolinuxify --help

echo "All installations are complete"