sudo apt update -y
sudo apt upgrade -y

cd ~/.local/share

rm -rf gitsleuth
git stash
git pull --force
cd ..

cd tsleuth 
git stash
git pull --force
cd ..

cd opkvs
git stash
git pull --force
cd ..

cd eolinuxify
git stash
git pull --force
cd ..