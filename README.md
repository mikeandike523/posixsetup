Assume WSL2 enabled


Inside Windows Command Prompt (Administrator)


Step 1 -- remove any existing ubuntu installation OR
If not installed before, install from microsoft store

    wsl --unregister ubuntu


Step 2 -- Open start menu and type Ubuntu
A ubuntu based terminal will open and you will be prompted to make an account


Step 3 -- Download installer script, run, and remove

    curl https://raw.githubusercontent.com/mikeandike523/wslsetup/main/wslsetup.sh -o wslsetup.sh
    bash wslsetup.sh
    rm -f wslsetup.sh

You may be prompted to enter your password