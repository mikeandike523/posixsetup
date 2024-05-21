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

if [ "$platform" = "linux" ] || [ "$platform" = "wsl" ]; then
    set +e
    if [ -n "$WSL_DISTRO_NAME" ]; then
        echo "WSL detected, proceeding with installation of wslu."
        sudo apt install -y wslu
    else
        echo "Not running under WSL, skipping installation of wslu."
    fi
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt-get install build-essential
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
# brew install npm

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
    sudo apt update && sudo apt install 1password-cli
}


if [ "$platform" = "linux" ] || [ "$platform" = "wsl" ]; then
    install_1password_cli_linux
else
    brew install --cask 1password-cli
fi



# Is idempotent, or will update to ltest version,
# so its okay to not check
npm install --global yarn
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

set +e

echo "All installations are complete"

echo "The easiest way to ensure your shell is up-to-date is to simply close your terminal and open it again"