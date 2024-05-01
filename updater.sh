sudo apt update -y
sudo apt upgrade -y

cd ~/.local/share

cd gitsleuth
git pull --force
cd ..

cd tsleuth 
git pull --force
cd ..

cd opkvs
git pull --force
cd ..

cd eolinuxify
git pull --force
cd ..