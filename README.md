# posixsetup

A setup utility dedicated to installing several useful tools on a fresh Linux, WSL, or MacOS machine

## Usage


### Run the installer

From inside Linux, WSL, or MacOS machine:

    cd ~ &&
    git clone https://github.com/mikeandike523/wslsetup &&
    bash wslsetup/setup.sh &&
    rm -rf wslsetup || rm -rf wslsetup

You may be prompted to enter your password one or more times.

To see properly changes to the PATH vairable, exit the terminal and open a new one

I could not get source ~/.bashrc to work reliably, but you can test it for yourself if you like.

This project is still in active development.

### Running the Updater

From inside Linux, WSL, or MacOS machine:

    cd ~ &&
    git clone https://github.com/mikeandike523/wslsetup &&
    bash wslsetup/update.sh &&
    rm -rf wslsetup || rm -rf wslsetu

You may be prompted to enter your password one or more times.

### Addendum: How to install or reinstall WSL Ubuntu

Install or Reinstall Ubuntu

If you already have Ubuntu (wsl) installed:

    wsl --unregister ubuntu

If not:

Go to microsoft store and download Ubuntu

open "Ubuntu" from the Windows start menu or search "Ubuntu" in the Windows search bar

A Ubuntu based terminal will open and you will be prompted to make an account
