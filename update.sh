#!/bin/bash

dn="$(dirname "$(realpath "$0")")"

source "$dn/utils.sh"

set -e

platform="$(detect_platform)"


if [ "$platform" = "linux" ] || [ "$platform" = "wsl" ]; then
    brewexc="/home/linuxbrew/.linuxbrew/bin/brew"
else
    brewexc="/opt/homebrew/bin/brew"
fi


function brew {
    "$brewexc" "$@"
}


if [ "$platform" = "linux" ] || [ "$platform" = "wsl" ]; then

    sudo apt-get update -y
    sudo apt-get upgrade -y

fi

brew update
brew upgrade

cd "$dn"

bash install_custom_tools.sh

set +e