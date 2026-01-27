# SPDX-License-Identifier: GPL-2.0

PKG_NAME="script.launcher.retroarch"
PKG_VERSION="1.22.2"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_DEPENDS_TARGET="retroarch retroarch_assets retroarch_joypad_autoconfig"
PKG_SECTION=""
PKG_SHORTDESC="Launch RetroArch (${PKG_VERSION})"
PKG_LONGDESC="RetroArch is a frontend for emulators, game engines and media players. The add-on provides binary, cores and basic settings to launch RetroArch from Kodi UI, plus additional features to improve user experience."
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="RetroArch"
PKG_ADDON_TYPE="xbmc.simple"
PKG_ADDON_EXTENSION="xbmc.python.pluginsource"
PKG_ADDON_PROVIDES="executable game"
PKG_MAINTAINER="s7a7ic"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/{bin,lib,resources}

  cp $(get_install_dir retroarch)/usr/bin/retroarch ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp -r $(get_install_dir retroarch_assets)/usr/share/retroarch/assets ${ADDON_BUILD}/${PKG_ADDON_ID}/resources/assets

  mkdir ${ADDON_BUILD}/${PKG_ADDON_ID}/resources/joypads
  cp -r $(get_install_dir retroarch_joypad_autoconfig)/etc/retroarch-joypad-autoconfig/* ${ADDON_BUILD}/${PKG_ADDON_ID}/resources/joypads
}
