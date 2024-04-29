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

# Install github cli

(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# Install software which allows software suich as github cli to open a browser window
# for tasks such as authnetication
if [ -n "$WSL_DISTRO_NAME" ]; then
    echo "WSL detected, proceeding with installation of wslu."
    sudo apt install -y wslu
else
    echo "Not running under WSL, skipping installation of wslu."
fi

# install 1password CLI

sudo rm -f /usr/share/keyrings/1password-archive-keyring.gpg
sudo rm -f /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
sudo curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
sudo curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
sudo sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo apt update && sudo apt install 1password-cli

mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/bin"

cd "$HOME/.local/share"
rm -rf gitsleuth
rm -rf tsleuth
rm -rf eolinuxify
rm -rf opkvs

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

cd "$HOME/.local/share"
git clone https://github.com/mikeandike523/opkvs
cd opkvs
sudo chmod +x ./configure
./configure
rm -f "$HOME/.local/bin/eoliopkvsnuxify"
create_symlink "$HOME/.local/share/opkvs/opkvs" "$HOME/.local/bin/opkvs"

cd "$dn"

python3 idem_profiles_add_path.py "$HOME/.local/bin"

export PATH="$PATH:$HOME/.local/bin"

gitsleuth --help
tsleuth --help
eolinuxify --help
opkvs --help

echo "All installations are complete"

set +e

echo ""
echo "Some additional useful commands:"
echo ""
echo "    \"gh auth login\" to sign into github via the github CLI"
echo "     TODO: 1password signin, signout, and switch account commands                                                 "
echo "    \"code .\" If you have vscode on your host machine"
echo "               and have \"code\" on host machine path"
echo "               then the vscode server will automatically be downloaded"
echo "               and vscode will be opened in the present working directory"
echo ""