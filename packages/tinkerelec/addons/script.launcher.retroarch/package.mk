# SPDX-License-Identifier: GPL-2.0

PKG_NAME="script.launcher.retroarch"
PKG_VERSION="1.22.2"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_DEPENDS_TARGET="retroarch"
PKG_SECTION=""
PKG_SHORTDESC="Launch RetroArch (${PKG_VERSION})"
PKG_LONGDESC="RetroArch is a frontend for emulators, game engines and media players. The add-on provides binary, cores and basic settings to launch RetroArch from Kodi UI, plus additional features to improve user experience."
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="RetroArch"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES="executable game"
PKG_MAINTAINER="s7a7ic"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/{bin,lib}

#  patchelf --add-rpath '${ORIGIN}/../lib.private' ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/snapclient

#  if [ "${ALSA_SUPPORT}" = yes ]; then
#    cp $(get_install_dir alsa-plugins)/usr/lib/alsa/*.so \
#       ${ADDON_BUILD}/${PKG_ADDON_ID}/lib.private
#  fi

  cp $(get_install_dir retroarch)/usr/bin/retroarch \
     ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
}
