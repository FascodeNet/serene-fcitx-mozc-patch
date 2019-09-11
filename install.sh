#!/bin/bash

# check i'm in gui or cli
if [[ -z $DISPLAY ]]; then
	# NO DISPLAY FOUND !!!! F*CK !!!!!!
	echo "You must run this script only in GUI !"
	exit 1
fi

# path to "config" dir
CONFIGDIR=~/serene-fcitx-mozc-patch/config
if [[ -z $CONFIGDIR/config ]]; then
	echo "No configration file found. Please configration fcitx by yourself."
	exit 1
fi

# run fcitx to get default config
#exec fcitx

# check the existence of fcitx config dir and put config to it
if [[ -e ~/.config/fcitx/config ]]; then

	# installing message
	echo "Placing custom settings to ~/.config/fcitx/ now..."

	# true
	cp -rb $CONFIGDIR/* ~/.config/fcitx/ && \
	echo "INSTALL CONFIGS IS SUCCESSFULLY !!!!" && \
	exit 0
fi

echo "Oops! It's error sorry. Please configuration fcitx by yourself."
exit 1
