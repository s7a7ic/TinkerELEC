#!/bin/sh

DTB_FILE="rk3288-tinker-s-nespi.dtb"
PKG_PATH="$2"

case $1 in
	check)
		if [ -f /flash/${DTB_FILE} ]; then
			cd /flash
			sha256sum -s -c "${PKG_PATH}/dtb/${DTB_FILE}.sha256"
			exit $?
		else
			exit 2
		fi
		;;
	install)
		mount -o remount,rw /flash
		cp ${PKG_PATH}/dtb/${DTB_FILE} /flash/
		sed -e "s,rk3288-tinker-s.dtb,rk3288-tinker-s-nespi.dtb,g" -i /flash/extlinux/extlinux.conf
		mount -o remount,ro /flash
		exit 0
		;;
	uninstall)
		mount -o remount,rw /flash
		sed -e "s,rk3288-tinker-s-nespi.dtb,rk3288-tinker-s.dtb,g" -i /flash/extlinux/extlinux.conf
		mount -o remount,ro /flash
		exit $?
		;;
esac
