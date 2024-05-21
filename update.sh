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

cd ~/.local/share

cd gitsleuth
git stash
git pull --force
sudo chmod +x ./configure
./configure
cd ..

cd tsleuth 
git stash
git pull --force
sudo chmod +x ./configure
./configure
cd ..

cd opkvs
git stash
git pull --force
sudo chmod +x ./configure
./configure
cd ..

cd eolinuxify
git stash
git pull --force
sudo chmod +x ./configure
./configure
cd ..

cd confy
git stash
git pull --force
sudo chmod +x ./configure
./configure
cd ..

set +e