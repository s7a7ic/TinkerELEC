# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="tinkerelec-init-config"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/s7a7ic/TinkerELEC-Project"
PKG_URL=""
PKG_DEPENDS_TARGET="kodi"
PKG_DEPENDS_UNPACK="kodi"
PKG_LONGDESC="TinkerELEC initial config for a fresh install."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/kodi/addons/peripheral.joystick/resources/buttonmaps/xml/linux/
    cp -a ${PKG_DIR}/files/*.xml ${INSTALL}/usr/share/kodi/addons/peripheral.joystick/resources/buttonmaps/xml/linux/
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/usr/config
    cp -PR ${PKG_DIR}/config/* ${INSTALL}/usr/config
}
