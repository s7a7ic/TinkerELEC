# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="kodi-theme-Estuary"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="kodi"
PKG_DEPENDS_UNPACK="kodi"
PKG_LONGDESC="Kodi Mediacenter default theme."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/kodi/addons/
    cp -a $(get_install_dir kodi)/.noinstall/skin.estuary ${INSTALL}/usr/share/kodi/addons/

  # smaller sidemenu
  if [ ! "${ESTUARY_SMALL_MENU}" = "no" ]; then
    echo "### Estuary Skin: smaller sidemenu ###"
    patch -d ${INSTALL}/usr/share/kodi/addons/skin.estuary -p1 < ${PKG_DIR}/files/kodi-theme-Estuary-100.01-smaller-sidemenu.patch
  fi

  # tv menu button first
  if [ ! "${ESTUARY_TV_FIRST}" = "no" ]; then
    echo "### Estuary Skin: tv menu first ###"
    patch -d ${INSTALL}/usr/share/kodi/addons/skin.estuary -p1 < ${PKG_DIR}/files/kodi-theme-Estuary-100.02-tv-menu-first.patch
  fi
}
