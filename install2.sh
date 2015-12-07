#!/bin/bash

CBIN=/usr/bin
CLIB=/usr/lib64
URL="https://raw.github.com/CodeBuds/Cri/master"
CTEMP=~/Downloads/.tmp #Keep this set to the .tmp so that nothing gets deleted
CROUBIN=/mnt/stateful_partition/crouton/chroots/precise/usr/bin

echo "Welcome to the second part of the installation"
echo "Developed by David Smerkous and Eli Smith"
sleep 1
echo "Starting..."
echo

ask() { #Same function called earlier in the previous script to use in yes/no situations
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
        read -p "$1 [$prompt] " REPLY </dev/tty
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

lineCount() #Same function called earlier in the previous script to use in the counting of lines in commands.txt
{
    wc -l < commands.txt	
}

lineCounttwo() #Same function called earlier in the previous script to use in the counting of lines in commands.txt
{
    wc -l < commands2.txt	
}
lineCountlib() #Same function called earlier in the previous script to use in the counting of lines in commands.txt
{
    wc -l < libs.txt	
}

libNames()
{
    cat libs.txt
}

if [ ! -d "$CTEMP" ]; then
    mkdir $CTEMP
fi 

#Gets all needed commands for Cri
cd $CTEMP
echo "Downloading Cri files" 
sudo wget -q --no-check-certificate "$URL/commands.txt" -O $CTEMP/commands.txt #This is to download list of files needed
sudo chmod 755 commands.txt #Makes the commands file have every permisson so that anyone can use it 
NAMES="$(< commands.txt)" #names from names.txt file
LINES=$(lineCount)
NUMBERS=1
cd $CBIN
for NAME in $NAMES; do #Downloads all nessisary files from github to /usr/local/bin
    echo "File $NUMBERS/$LINES..."
    let "NUMBERS += 1"
    sudo wget -q --no-check-certificate "$URL/$NAME" -O $CBIN/${NAME##*/}
    sudo chmod 755 ${NAME##*/}
done

#This next chunk installs certain files directly into the chroot 
cd $CTEMP
echo "Downloading crouton files" 
sudo wget -q --no-check-certificate "$URL/commands2.txt" -O $CTEMP/commands2.txt #This is to download list of files needed
sudo chmod 755 commands2.txt #Makes the commands file have every permisson so that anyone can use it 
NAMES="$(< commands2.txt)" #names from names.txt file
LINES=$(lineCounttwo)
NUMBERS=1
cd /mnt/stateful_partition/crouton/chroots/*/usr/bin
for NAME in $NAMES; do #Downloads all nessisary files from github to /usr/local/bin
    echo "File $NUMBERS/$LINES..."
    let "NUMBERS += 1"
    sudo wget -q --no-check-certificate "$URL/$NAME" -O ${NAME##*/}
    sudo chmod 755 ${NAME##*/}
done

#Gets needed libraries for Cri
cd $CLIB

sudo wget -q http://tinyurl.com/libtinfo-so-5 -O libtinfo.so.5
sudo wget -q http://tinyurl.com/libncursesw-so-5 -O libncursesw.so.5
sudo chmod 755 libtinfo.so.5
sudo chmod 755 libncursesw.so.5

cd $CBIN #Adds the "dialog" command to the bin
sudo wget -q "https://www.dropbox.com/s/9be2q324fxzlz00/dialog?raw=1" -O dialog
sudo chmod 755 dialog
#This makes it so that whenever ctrl+alt+t is pressed, http://download1339.mediafire.com/1y9uo9vg87tg/54t1f8e7wcl5hta/libncursesw.so.5we launch directly into Cri
cd $CBIN
sudo mv /usr/bin/crosh /usr/bin/.crosh_backup
sudo mv cri /usr/bin/crosh 
echo "Done..."
echo

if ask "Would you like to fix the current config file? (RECOMMENDED)"; then #Fixes the extention so that it works right 
  sudo fixconfig
fi

if ask "Would you like to install the academy package? (HIGHLY RECOMMENDED)"; then
  sudo acadapkg
fi

cd ~/Downloads
sudo mkdir ~/Downloads/.tmp 2&>/dev/null
sudo echo >~/Downloads/.tmp/coms
sudo chown chronos:chronos ./.tmp/coms
unset CTEMP
writer "apt-get install dialog thunar gnome-icon-theme-extras gnome-icon-theme-full"
sleep 0.5
sudo enter-chroot -u root runner
exit 0
