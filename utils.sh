#!/bin/bash

detect_platform() {
    case "$(uname -s)" in
        Darwin)
            echo "darwin"
            return 0
            ;;
        Linux)
            if grep -q Microsoft /proc/version; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        *)
          
            echo  "Unsupported platform. This script only supports macOS, Linux, and Windows Subsystem for Linux (WSL)." >&2
            exit 1
            ;;
    esac
}

create_symlink() {
    local target="$1"
    local link_name="$2"

    # Check if the symbolic link already exists
    if [ -L "${link_name}" ]; then
        # The symlink exists, check if it points to the correct target
        if [ "$(readlink "${link_name}")" = "${target}" ]; then
            echo "Symlink already exists and points to the correct target: ${link_name} -> ${target}"
        else
            # The existing symlink points to the wrong target, update it
            echo "Updating symlink to point to the correct target: ${link_name} -> ${target}"
            ln -sf "${target}" "${link_name}"
        fi
    elif [ -e "${link_name}" ]; then
        # The link name exists but is not a symlink, output an error or handle as needed
        echo "Error: ${link_name} exists but is not a symlink. Please handle manually."
    else
        # The symlink does not exist, create it
        echo "Creating new symlink: ${link_name} -> ${target}"
        ln -s "${target}" "${link_name}"
    fi
}