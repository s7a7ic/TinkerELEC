# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="tinkerelec-project"
PKG_VERSION="9ae6bc5b88c0f06133c5acd0ed6275c13fc01f41"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/s7a7ic/TinkerELEC-Project"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="This package pulls the TinkerELEC configuration for the addon."
PKG_TOOLCHAIN="manual"

#makeinstall_target() {
#  mkdir -p ${INSTALL}/usr/share/kodi/addons/peripheral.joystick/resources/buttonmaps/xml/linux/
#  cp -a ${PKG_DIR}/files/*.xml ${INSTALL}/usr/share/kodi/addons/peripheral.joystick/resources/buttonmaps/xml/linux/
#}

#post_makeinstall_target() {
#  mkdir -p ${INSTALL}/usr/config
#  cp -PR ${PKG_DIR}/config/* ${INSTALL}/usr/config
#}
