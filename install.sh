#!/bin/bash

EDIR=$PWD

# check i'm in gui or cli
if [[ -z $DISPLAY ]]; then
	# NO DISPLAY FOUND !!!! 
	echo "You must run this script only in GUI !"
	exit 1
fi

# path to ExtractedDirectory
EDIR=~/serene-fcitx-mozc-patch
if [[ -z $EDIR/config/config ]]; then
	echo "No configration file found. Please configration fcitx by yourself."
	exit 1
fi

fcitx -r > /dev/null 2>&1 &

# check the existence of fcitx config dir and put config to it
if [[ ! -e ~/.config/fcitx/config ]]; then

cat << EOS
-----------------------------------------
!!!! PLEASE RELAUNCH THE INSTALLER !!!! 
-----------------------------------------
EOS

	exec fcitx > /dev/null 2>&1 && \
	exit 2
fi

# keyboard layout jp or us
echo "Keymap to use (jp106):1 (US):2 Default=1 : "
read ANSWER

case $ANSWER in
	"1" ) CHOSELANG=jp && echo "Keymap is jp106";;
	"2" ) CHOSELANG=us && echo "Keymap is US";;
	"" ) CHOSELANG=jp && echo "Keymap is jp106";;
	* ) echo "error" && exit 1;;
esac

# Ask root password.
printf "Please enter your password. (The password is used to create setting files.)"
read -sp root_password

# installing message
echo "Placing custom settings to ~/.config/fcitx/ now..."
cp -rb $EDIR/config/config-$CHOSELANG ~/.config/fcitx/config && \
cp -rb $EDIR/profile/profile-$CHOSELANG ~/.config/fcitx/profile && \
cp -rb $EDIR/conf ~/.config/fcitx/ && \
echo $root_password | sudo -s cp -rb $EDIR/config/config-$CHOSELANG /etc/skel/.config/fcitx/config && \
echo $root_password | sudo -s cp -rb $EDIR/profile/profile-$CHOSELANG /etc/skel/.config/fcitx/profile && \
echo $root_password | sudo -s cp -rb $EDIR/conf /etc/skel/.config/fcitx/ && \

# add config to xprofile for other linux distro
#cat ~/.xprofile | grep "GTK_IM_MODULE=fcitx" > /dev/null
if [[ -f /etc/os-release ]]; then
	source /etc/os-release
else
	echo "/ etc / os-release does not exist." >&2
	ID_LIKE=other
fi

if [[ $? = 0 -a ! $ID_LIKE = "debian" ]]; then
	echo GTK_IM_MODULE=fcitx >> ~/.xprofile
	echo QT_IM_MODULE=fcitx >> ~/.xprofile
	echo XMODIFIERS=@im=fcitx >> ~/.xprofile
	echo $root_password | sudo -s echo GTK_IM_MODULE=fcitx >> ~/.xprofile
	echo $root_password | sudo -s echo QT_IM_MODULE=fcitx >> ~/.xprofile
	echo $root_password | sudo -s echo XMODIFIERS=@im=fcitx >> ~/.xprofile
fi

cat << EOS
--------------------------------------
INSTALL CONFIGS IS SUCCESSFULLY !!!! 
--------------------------------------
EOS
exec fcitx -r > /dev/null 2>&1 && \
exit 0

