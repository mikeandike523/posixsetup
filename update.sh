#!/bin/bash

dn="$(dirname "$(realpath "$0")")"

source "$dn/utils.sh"

alias brew="/home/linuxbrew/.linuxbrew/bin/brew"

set -e

platform="$(detect__platform)"

if []


if [ "$platform" = "linux"] || [ "$platform" = "wsl"]; then

    sudo apt-get update -y
    sudo apt-get upgrade -y

elif ["$platform" = "darwin"]; then

    brew update -y
    brew upgrade -y
    
else

    echo "Unsupported platform: $(uname -s) ($(uname))"
    exit 1

fi

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