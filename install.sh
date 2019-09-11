#!/bin/bash

# check i'm in gui or cli
if [[ -z $DISPLAY ]]; then
	# NO DISPLAY FOUND !!!! F*CK !!!!!!
	echo "You must run this script only in GUI !"
	exit 1
fi

# path to ExtractedDirectory
EDIR=~/serene-fcitx-mozc-patch
if [[ -z $EDIR/config/config ]]; then
	echo "No configration file found. Please configration fcitx by yourself."
	exit 1
fi

# check the existence of fcitx config dir and put config to it
if [[ ! -e ~/.config/fcitx/config ]]; then

	echo "-----------------------------------------"
	echo " !!!! PLEASE RELAUNCH THE INSTALLER !!!! "
	echo "-----------------------------------------"
	exec fcitx > /dev/null 2>&1 && \
	exit 1
fi

# keyboard layout jp or us
echo "Keymap to use ja_JP:1 en_US:2 (1/2) Default=1 : "
read ANSWER

case $ANSWER in
	"2" ) CHOSELANG=us && echo "Keymap is en_US";;
	* ) CHOSELANG=jp && echo "Keymap is ja_JP";;
esac

# installing message
echo "Placing custom settings to ~/.config/fcitx/ now..."
cp -rb $EDIR/config/config-$CHOSELANG ~/.config/fcitx/config && \
cp -rb $EDIR/profile/profile-$CHOSELANG ~/.config/fcitx/profile && \
cp -rb $EDIR/conf ~/.config/fcitx/ && \

# add config to xprofile for other linux distro
#cat ~/.xprofile | grep "GTK_IM_MODULE=fcitx" > /dev/null
#if [[ $? = 0 ]]; then
#	echo GTK_IM_MODULE=fcitx >> ~/.xprofile
#	echo QT_IM_MODULE=fcitx >> ~/.xprofile
#	echo XMODIFIERS=@im=fcitx >> ~/.xprofile
#fi

echo "--------------------------------------"
echo " INSTALL CONFIGS IS SUCCESSFULLY !!!! "
echo "--------------------------------------"
exec fcitx -r > /dev/null 2>&1 && \
exit 0

