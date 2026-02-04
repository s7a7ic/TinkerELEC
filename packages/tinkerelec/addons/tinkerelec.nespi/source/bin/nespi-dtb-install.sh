#!/bin/sh

DTB_FILE="rk3288-tinker-s-nespi.dtb"
PKG_PATH="/storage/.kodi/addons/script.tinkerelec.nespi"

check_extlinux() {
	# if modified dtb is set in extlinux.conf then echo 1 else echo 0
	grep -q ${DTB_FILE} /flash/extlinux/extlinux.conf && echo 1 || echo 0
}

check_sha256() {
	cd /flash
	sha256sum -s -c "${PKG_PATH}/dtb/${DTB_FILE}.sha256"
	echo $?
}

if [ $# -eq 0 ]; then
    echo 'supported arguments: check, install, uninstall'
    exit 0
fi

case $1 in
	check)
		if [ -f /flash/${DTB_FILE} ]; then
			if [ $(check_extlinux) = 0 ]; then
				echo "DTB file is in /flash but not configured in extlinux.conf"
			elif [ $(check_sha256) = 1 ]; then
				echo "DTB file checksum missmatch"
				exit 2
			else
			  exit 0
			fi
		else
			echo "DTB file is not in /flash"
		fi
		exit 1
		;;
	install)
		mount -o remount,rw /flash
		cp ${PKG_PATH}/dtb/${DTB_FILE} /flash/
		[ $(check_extlinux) = 0 ] && sed -e "s,rk3288-tinker-s.dtb,${DTB_FILE},g" -i /flash/extlinux/extlinux.conf
		mount -o remount,ro /flash
		echo "DTB install finished"
		exit $(check_sha256)
		;;
	uninstall)
		mount -o remount,rw /flash
		sed -e "s,${DTB_FILE},rk3288-tinker-s.dtb,g" -i /flash/extlinux/extlinux.conf
		mount -o remount,ro /flash
		echo "DTB uninstall finished"
		exit $(check_extlinux)
		;;
esac
