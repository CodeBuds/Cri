#!/bin/sh
#Directories for all files
AUTHORS="David Smerkous and Eli Smith"
MODIFIERS="NONE"
URL="https://raw.github.com/CodeBuds/Cri/master"
CRIBIN=/usr/bin

cd 
cd Downloads
echo 'Welcome to the Cri installer, this will install Cri in 5 seconds, hit ctrl+z to stop if unwanted'
sleep 5

user=$(whoami)
architecture=$(uname -m)

echo "You are running as $USER, and on a $ARCHITECTURE computer"
echo ""
echo "Developed by $AUTHORS"
echo ""

sleep 2

ask() {
    # http://djm.me/ask
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question - use /dev/tty in case stdin is redirected from somewhere else
        read -p "$1 [$prompt] " REPLY </dev/tty

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}
if ask "Is Cri already on your system? [y] or [n]"; then
    echo "Installing secondary then..."
else
    echo "Installing pre files"
    sudo wget "https://raw.githubusercontent.com/dnschneid/crouton/master/installer/crouton" --no-check-certificate -q
    echo "Done"
    echo "..."
    sleep 1
    echo "Installing"
    sudo chmod +x crouton
    sudo sh crouton -t e17,xiwi
    echo ""
    echo "Done installing second os (Ubunut-core)"
    echo ""
    echo "Installing"
fi

sleep 1

cd
cd Downloads
echo "Installing secondary files"
echo "1/11..."
sudo wget "$URL/commands/rootmount" --no-check-certificate -q
echo "2/11..."
sudo wget "$URL/commands/unmount" --no-check-certificate -q
echo "3/11..."
sudo wget "$URL/commands/install" --no-check-certificate -q
echo "4/11..."
sudo wget "$URL/commands/remove" --no-check-certificate -q
echo "5/11..."
sudo wget "$URL/commands/run" --no-check-certificate -q
echo "6/11..."
sudo wget "$URL/commands/search" --no-check-certificate -q
echo "7/11..."
sudo wget "$URL/commands/stop" --no-check-certificate -q
echo "8/11..."
sudo wget "$URL/commands/uninstall" --no-check-certificate -q
echo "9/11..."
sudo wget "$URL/commands/update" --no-check-certificate -q
echo "10/11..."
sudo wget "$URL/commands/reinstall" --no-check-certificate -q
echo "11/11..."
sudo wget "$URL/cri" --no-check-certificate -q
echo "Done installing secondary files"
sleep 1
cd
cd Downloads
echo "Changing the permissions"
sudo chmod +x rootmount
sudo chmod +x unmount
sudo chmod +x install
sudo chmod +x remove
sudo chmod +x run
sudo chmod +x search
sudo chmod +x stop
sudo chmod +x uninstall
sudo chmod +x update
sudo chmod +x reinstall
sudo chmod +x cri
echo "Done changing permissions"
echo ""
echo ""

sleep 2

echo "Changing the mounts to be root read/write"
echo "As soon as you mount your system as root reboot, the program will ask you in less"
echo "than 15 seconds"
sleep 15
sudo sh rootmount
