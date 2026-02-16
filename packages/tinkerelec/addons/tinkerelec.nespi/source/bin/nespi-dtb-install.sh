#!/bin/sh

PKG_PATH="/storage/.kodi/addons/script.tinkerelec.nespi"
DTB_FILE_NEW="rk3288-tinker-s-nespi.dtb"
DTB_FILE_DEFAULT="rk3288-tinker-s.dtb"

. /etc/os-release

usage() {
	echo "usage: $0 [check|install|uninstall]"
	echo ""
	echo "  check     - check if dtb is installed"
	echo "  install   - copy dtb into /flash and configure extlinux.conf"
	echo "  uninstall - configure extlinux.conf to default dtb"
}

check_extlinux() {
	# if modified dtb is set in extlinux.conf then echo 1 else echo 0
	grep -q ${DTB_FILE_NEW} /flash/extlinux/extlinux.conf && echo 1 || echo 0
}

check_sha256() {
	cd /flash
	sha256sum -s -c "${PKG_PATH}/dtb/${DTB_FILE_NEW}.sha256"
	echo $?
}

case $1 in
	check)
		[ $DISTRO_DEVICE != "RK3288" -a $DISTRO_DEVICE != "TinkerBoard" ] && exit 3
		if [ -f /flash/${DTB_FILE_NEW} ]; then
			if [ $(check_extlinux) = 0 ]; then
				echo "DTB file is in /flash but not configured in extlinux.conf"
			elif [ $(check_sha256) = 1 ]; then
				echo "DTB file checksum missmatch"
				exit 2
			else
				echo "DTB file is installed"
				exit 0
			fi
		else
			echo "DTB file is not installed"
		fi
		exit 1
		;;

	install)
		mount -o remount,rw /flash
		cp ${PKG_PATH}/dtb/${DTB_FILE_NEW} /flash/
		[ $(check_extlinux) = 0 ] && sed -e "s,${DTB_FILE_DEFAULT},${DTB_FILE_NEW},g" -i /flash/extlinux/extlinux.conf
		mount -o remount,ro /flash
		echo "DTB install finished, reboot required"
		exit $(check_sha256)
		;;

	uninstall)
		mount -o remount,rw /flash
		sed -e "s,${DTB_FILE_NEW},${DTB_FILE_DEFAULT},g" -i /flash/extlinux/extlinux.conf
		mount -o remount,ro /flash
		echo "DTB uninstall finished, reboot required"
		exit $(check_extlinux)
		;;

	*)
		usage
		exit 1
		;;
esac
