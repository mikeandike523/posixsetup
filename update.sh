#!/bin/bash

set -e

sudo apt update -y
sudo apt upgrade -y

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