#!/bin/sh

RA_CONFIG_DIR=$HOME/.config/retroarch
RA_CONFIG_FILE=$RA_CONFIG_DIR/retroarch.cfg
[ ! -f "$RA_CONFIG_FILE" ] && RA_CONFIG_FILE="${ADDON_SRC}/config/retroarch.cfg"

case $1 in
	check)
#		get_update_url
		exit $?
		;;
	check_assets)
		ASSETS_DIR=$(cat "$RA_CONFIG_FILE" 2>/dev/null | grep ^assets_directory | head -n 1 | sed -e 's|.*= *||' -e 's|"||g' -e "s|~|$HOME|")
		[ -z "$(ls -A $ASSETS_DIR 2>/dev/null)" ] && exit 0 || exit 1
		;;
	clear_flags)
#		clear_flags
		exit $?
		;;
	clear_cfg)
#		ra_cfg_backup_clear
		exit $?
		;;
	install*)
#		ra_install "$1" "$2" "$3" "$4" "$5"
		exit $?
		;;
esac
