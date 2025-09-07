# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="kodi-buttonmaps"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="kodi"
PKG_DEPENDS_UNPACK="kodi"
PKG_LONGDESC="Kodi Mediacenter buttonmaps."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/kodi/addons/peripheral.joystick/resources/buttonmaps/xml/linux/
    cp -a ${PKG_DIR}/files/*.xml ${INSTALL}/usr/share/kodi/addons/peripheral.joystick/resources/buttonmaps/xml/linux/
}
