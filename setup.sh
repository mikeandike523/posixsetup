#!/bin/bash

set -e

dn="$(dirname "$(realpath "$0")")"

source "$dn/utils.sh"

alias brew="/home/linuxbrew/.linuxbrew/bin/brew"

platform="$(detect_platform)"

echo "Found platform: "$platform""

if [ "$platform" = "linux" ] || [ "$platform" = "wsl" ]; then
    set +e
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt-get install build-essential
    sudo apt install -y python3-pip python3-venv python3-virtualenv
    set -e
fi


if [-e "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update -y
brew upgrade -y


brew install git
brew install gcc
brew install docker docker-compose
brew install gh
brew install 1password-cli
brew install node

# Is idempotent, or will update to ltest version,
# so its okay to not check
sudo npm install --global yarn
yarn --version

# Install custom tools

mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/bin"

cd "$HOME/.local/share"
rm -rf confy
rm -rf gitsleuth
rm -rf tsleuth
rm -rf eolinuxify
rm -rf opkvs

# Define a function to clone and set up a project
setup_project() {
    local project_name="$1"
    local base_dir="$HOME/.local/share"
    local bin_dir="$HOME/.local/bin"

    # Navigate to the base directory and clone the project
    cd "$base_dir"
    git clone "https://github.com/mikeandike523/$project_name"

    # Navigate into the project directory
    cd "$project_name"

    # Make the configure script executable and run it
    sudo chmod +x ./configure
    ./configure

    # Remove any existing symlink in the bin directory and create a new one
    rm -f "$bin_dir/$project_name"
    create_symlink "$base_dir/$project_name/$project_name" "$bin_dir/$project_name"
}

# Call the function for each project
setup_project "gitsleuth"
setup_project "tsleuth"
setup_project "eolinuxify"
setup_project "opkvs"
setup_project "confy"

cd "$dn"

python3 idem_profiles_add_path.py "$HOME/.local/bin"

export PATH="$PATH:$HOME/.local/bin"

confy --help
gitsleuth --help
tsleuth --help
eolinuxify --help
opkvs --help
echo "Adding user $USER to docker group..."

sudo usermod -aG docker $USER

set +e

echo "All installations are complete"

echo "The easiest way to ensure your shell is up-to-date is to simply close your terminal and open it again"