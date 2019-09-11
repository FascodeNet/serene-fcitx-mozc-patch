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

# keyboard layout jp or us
echo "Keymap to use ja_JP:1 en_US:2 (1/2) Default=1 : "
read ANSWER

case $ANSWER in
	"2" ) CHOSELANG=us && echo "en_US";;
	* ) CHOSELANG=jp && echo "ja_JP";;
esac

# check the existence of fcitx config dir and put config to it
if [[ -e ~/.config/fcitx/config ]]; then

	# installing message
	echo "Placing custom settings to ~/.config/fcitx/ now..."

	# true
	echo $EDIR
	cp -rb $EDIR/config/* ~/.config/fcitx/ && \
	cp -rb $EDIR/profile/profile-$CHOSELANG ~/.config/fcitx/profile && \
	echo "INSTALL CONFIGS IS SUCCESSFULLY !!!!" && \
	exec fcitx -r > /dev/null 2>&1 && \
	exit 0
else
	echo "Please relunch this installer again."
	exec fcitx > /dev/null 2>&1 && \
	exit 1
fi

echo "Oops! It's error sorry. Please configuration fcitx by yourself."
exit 1
