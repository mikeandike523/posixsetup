# Install custom tools

dn="$(dirname "$(realpath "$0")")"

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

cd /usr/local/src

sudo git clone https://github.com/mikeandike523/confy

cd confy

sudo chmod +x ./configure

sudo ./configure

cd "$dn"

python3 idem_profiles_add_path.py "$HOME/.local/bin"

export PATH="$PATH:$HOME/.local/bin"

confy --help
gitsleuth --help
tsleuth --help
eolinuxify --help
opkvs --help