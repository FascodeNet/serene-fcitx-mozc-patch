#!/bin/bash

# Are u superuser?
if [ ! $UID -eq 0 ]; then
	echo "Permisson denied."
	exit 1
fi

# extracted directory
EDIR=$(cd $(dirname $0); pwd)

# real username
USERNAME=${SUDO_USER:-$USER}

# check env to install
if [ -z $DISPLAY ]; then
	# NO DISPLAY FOUND !!!! 
	echo "You must run this script only in GUI !"
	exit 1
elif [ ! $USERNAME == $USER ]; then
	if [ ! -d /home/$USERNAME ]; then
		echo "Couldn't find homedirectory."
		exit 1
	fi
	HOMEDIR=/home/$USERNAME
else
	HOMEDIR=/root
fi

# relaunch fcitx
if pidof fcitx >/dev/null 2>&1; then
	fcitx -r >/dev/null 2>&1 &
else
	fcitx >/dev/null 2>&1 &
fi


# keyboard layout jp or us
echo "Keymap to use (jp106):1 (US):2 Default=1 : "
read ANSWER

case $ANSWER in
	"1" ) CHOSEMAP=jp && echo "Keymap is jp106";;
	"2" ) CHOSEMAP=us && echo "Keymap is US";;
	"" ) CHOSEMAP=jp && echo "Keymap is jp106";;
	* ) echo "error" && exit 1;;
esac


echo "Placing custom settings..."
# local change
cp -rb $EDIR/config/config-$CHOSEMAP $HOMEDIR/.config/fcitx/config && \
cp -rb $EDIR/profile/profile-$CHOSEMAP $HOMEDIR/.config/fcitx/profile && \
cp -rb $EDIR/conf $HOMEDIR/.config/fcitx/ && \
# apply for systemwide
cp -rb $EDIR/config/config-$CHOSEMAP /etc/skel/.config/fcitx/config && \
cp -rb $EDIR/profile/profile-$CHOSEMAP /etc/skel/.config/fcitx/profile && \
cp -rb $EDIR/conf /etc/skel/.config/fcitx/ && \


# edit xprofile
if [ -f $HOMEDIR/.xprofile ]; then
	sed -i '/GTK_IM_MODULE/s/^/#/g' $HOMEDIR/.xprofile
	sed -i '/QT_IM_MODULE/s/^/#/g' $HOMEDIR/.xprofile
	sed -i '/XMODIFIERS=@im/s/^/#/g' $HOMEDIR/.xprofile
fi
# edit systemwide
if [ -f /etc/skel/.xprofile ]; then
	sed -i '/GTK_IM_MODULE=/s/^/#/g' /etc/skel/.xprofile
	sed -i '/QT_IM_MODULE=/s/^/#/g' /etc/skel/.xprofile
	sed -i '/XMODIFIERS=@im=/s/^/#/g' /etc/skel/.xprofile
fi

# local change
echo GTK_IM_MODULE=fcitx >> $HOMEDIR/.xprofile
echo QT_IM_MODULE=fcitx >> $HOMEDIR/.xprofile
echo XMODIFIERS=@im=fcitx >> $HOMEDIR/.xprofile
# systemwide
echo GTK_IM_MODULE=fcitx >> /etc/skel/.xprofile
echo QT_IM_MODULE=fcitx >> /etc/skel/.xprofile
echo XMODIFIERS=@im=fcitx >> /etc/skel/.xprofile

fcitx -r >/dev/null 2>&1 && \
cat << EOS
--------------------------------------
INSTALL CONFIGS IS SUCCESSFULLY !!!! 
--------------------------------------
EOS
exit 0

