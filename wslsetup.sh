#!/bin/bash

set -e

dn="$(dirname "$(realpath "$0")")"

create_symlink() {
    local target="$1"
    local link_name="$2"

    # Check if the symbolic link already exists
    if [ -L "${link_name}" ]; then
        # The symlink exists, check if it points to the correct target
        if [ "$(readlink "${link_name}")" = "${target}" ]; then
            echo "Symlink already exists and points to the correct target: ${link_name} -> ${target}"
        else
            # The existing symlink points to the wrong target, update it
            echo "Updating symlink to point to the correct target: ${link_name} -> ${target}"
            ln -sf "${target}" "${link_name}"
        fi
    elif [ -e "${link_name}" ]; then
        # The link name exists but is not a symlink, output an error or handle as needed
        echo "Error: ${link_name} exists but is not a symlink. Please handle manually."
    else
        # The symlink does not exist, create it
        echo "Creating new symlink: ${link_name} -> ${target}"
        ln -s "${target}" "${link_name}"
    fi
}

safe_source() {
    local file="$1"
    if [[ -f "$file" ]]; then
        echo "Sourcing ${file}..."
        source "$file"
    else
        echo "Warning: ${file} not found. Skipping."
    fi
}

sudo apt-get update -y
sudo apt-get upgrade -y

sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update -y
sudo apt install -y  python3.12 python3.12-venv
sudo apt install -y python3-pip python3-venv python3-virtualenv

sudo apt-get -y install software-properties-common

curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo npm install -g npm@latest

node --version
npm --version

sudo npm install --global yarn

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

mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/bin"

cd "$HOME/.local/share"
rm -rf gitsleuth
rm -rf tsleuth
rm -rf eolinuxify

cd "$HOME/.local/share"
git clone https://github.com/mikeandike523/gitsleuth
cd gitsleuth
python3.12 -m venv pyenv
source pyenv/bin/activate
pip install -r requirements.txt
deactivate
rm -f "$HOME/.local/bin/gitsleuth"
create_symlink "$HOME/.local/share/gitsleuth/gitsleuth" "$HOME/.local/bin/gitsleuth"

cd "$HOME/.local/share"
git clone https://github.com/mikeandike523/tsleuth
cd tsleuth
yarn install
yarn run build-all
rm -f "$HOME/.local/bin/tsleuth"
create_symlink "$HOME/.local/share/tsleuth/tsleuth" "$HOME/.local/bin/tsleuth"

cd "$HOME/.local/share"
git clone https://github.com/mikeandike523/eolinuxify
cd eolinuxify
sudo chmod +x ./configure
./configure
rm -f "$HOME/.local/bin/eolinuxify"
create_symlink "$HOME/.local/share/eolinuxify/eolinuxify" "$HOME/.local/bin/eolinuxify"

cd "$dn"

python3 idem_profiles_add_path.py "$HOME/.local/bin"

export PATH="$PATH:$HOME/.local/bin"

gitsleuth --help
tsleuth --help
eolinuxify --help

echo "All installations are complete"