#!/usr/bin/env python3

import os
import argparse

def find_profile_files():
    # Define the order of preference for profile files for each shell
    home = os.path.expanduser("~")
    profiles = {
        "bash": [".bashrc", ".bash_profile", ".bash_login"],
        "zsh": [".zshrc", ".zprofile"],
    }

    # Search for existing profile files in the user's home directory
    existing_profiles = {}
    for shell, files in profiles.items():
        for file in files:
            filepath = os.path.join(home, file)
            if os.path.isfile(filepath):
                if shell not in existing_profiles:
                    existing_profiles[shell] = filepath
    return existing_profiles

def add_path_to_profile(filepath, new_path):
    # Prepare the idempotent path addition command
    command = f"export PATH=\"$PATH:{new_path}\""
    idempotent_command = (
        "# Ensure path is only added once\n"
        f'if [[ ":$PATH:" != *":{new_path}:"* ]]; then\n'
        f'    {command}\n'
        "fi\n"
    )

    # Check if the command is already in the file
    with open(filepath, 'r+') as file:
        lines = file.readlines()
        if any(new_path in line for line in lines):
            print(f"No changes needed for {filepath}")
        else:
            # Add the command to the end of the file
            file.write(f"\n{idempotent_command}\n")
            print(f"Updated {filepath}")

def main():
    parser = argparse.ArgumentParser(description="Add a path to shell profiles in an idempotent manner.")
    parser.add_argument('path', type=str, help="The path to add to the shell profiles.")
    args = parser.parse_args()

    new_path = args.path
    profile_files = find_profile_files()

    if not profile_files:
        print("No shell profile files found.")
        return

    for shell, filepath in profile_files.items():
        add_path_to_profile(filepath, new_path)

if __name__ == "__main__":
    main()