#!/bin/bash

set -e

dn="$(dirname "$(realpath "$0")")"

source "$dn/utils.sh"



platform="$(detect_platform)"

echo "Found platform: "$platform""

if [ "$platform" = "linux" ] || [ "$platform" = "wsl" ]; then
    brewexc="/home/linuxbrew/.linuxbrew/bin/brew"
else
    brewexc="/opt/homebrew/bin/brew"
fi


function brew {
    "$brewexc" "$@"
}

function install_wslu {
    # Works for ubuntu
    # todo - make it more flexible as it may  crash on other linux distros
    sudo add-apt-repository -y ppa:wslutilities/wslu
    sudo apt update -y
    sudo apt install wslu -y
}

if [ "$platform" = "linux" ] || [ "$platform" = "wsl" ]; then
    set +e
    if [ -n "$WSL_DISTRO_NAME" ]; then
        echo "WSL detected, proceeding with installation of wslu."
        install_wslu
    else
        echo "Not running under WSL, skipping installation of wslu."
    fi
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt-get install build-essential -y
    sudo apt install -y python3-pip python3-venv python3-virtualenv
    set -e
fi


# if [ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ "$platform" = "linux" ] || [ "$platform" = "wsl" ]; then
    if [ ! -f "/home/$USER/.bashrc" ]; then
        touch "/home/$USER/.bashrc"
    fi

    if [ ! -f "/home/$USER/.zshrc" ]; then
        touch "/home/$USER/.zshrc"
    fi
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "/home/$USER/.bashrc"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    if [ ! -f "/Users/$USER/.bashrc" ]; then
        touch "/Users/$USER/.bashrc"
    fi

    if [ ! -f "/Users/$USER/.zshrc" ]; then
        touch "/Users/$USER/.zshrc"
    fi
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "/Users/$USER/.zshrc"
    eval "$(/opt/homebrew/bin/brew shellenv)"

fi

# fi


brew update
brew upgrade


brew install git
brew install gcc
brew install docker docker-compose
brew install gh
brew install node

function install_1password_cli_linux {
        
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
    sudo apt update -y && sudo apt install 1password-cli -y
}


if [ "$platform" = "linux" ] || [ "$platform" = "wsl" ]; then
    install_1password_cli_linux
else
    brew install --cask 1password-cli
fi


npm install --global yarn
yarn --version

cd "$dn"

bash install_custom_tools.sh

set +e

echo "All installations are complete"

echo "The easiest way to ensure your shell is up-to-date is to simply close your terminal and open it again"