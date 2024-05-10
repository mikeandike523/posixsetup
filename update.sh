#!/bin/bash

set -e

sudo apt update -y
sudo apt upgrade -y

cd ~/.local/share

cd gitsleuth
git stash
git pull --force
./update
cd ..

cd tsleuth 
git stash
git pull --force
./update
cd ..

cd opkvs
git stash
git pull --force
./update
cd ..

cd eolinuxify
git stash
git pull --force
./update
cd ..

cd confy
git stash
git pull --force
./update
cd ..

set +e