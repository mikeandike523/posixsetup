# wslsetup

A setup utility dedicated to installing several useful tools on a fresh wsl Ubuntu machine

## Usage

Assume WSL2 enabled

### Step 1

Install or Reinstall Ubuntu

If you already have Ubuntu (wsl) installed:

    wsl --unregister ubuntu

If not:

Go to microsoft store and download Ubuntu

### Step 2

open "Ubuntu" from the Windows start menu or search "Ubuntu" in the Windows search bar

A Ubuntu based terminal will open and you will be prompted to make an account

#### Recommendations

 - Use an all-lowercase alphanumeric username with no spaces or special characters
   - For instance, you can use a lowercase and no-space version of your windows user account name
 - Use a simple but memorable password, separate from your windows password, or use a randomly generated password, and record it in a password manager
     - To access your wsl machine, a hacker would have already had to b een able to compromise your main ("host") machine. Due to that added layer, it may not be necessary to use an auto-generated password
 
#### Step 3

Run the following commands line by line

Line 4 is the main installer script and takes the most time

You may be prompted one or more times to enter your user password

This is necessary as some installation operations require superuser privileges

    cd ~
    git clone https://github.com/mikeandike523/wslsetup
    cd wslsetup
    bash wslsetup.sh
    cd ~
    rm -rf wslsetup

#### Step 4

Close the current window, and run Ubuntu from the windows start menu

You can simply type "Ubuntu" in the windows search bar

The `gitsleuth`, `tsleuth`, and `eolinuxify` commands will not be available until you close and reopen your terminal window, or reload your user terminal profile using commands such as `source ~/.bashrc`