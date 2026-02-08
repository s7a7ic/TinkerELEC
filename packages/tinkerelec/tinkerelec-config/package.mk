# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="tinkerelec-config"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/s7a7ic/TinkerELEC-Project"
PKG_URL=""
PKG_DEPENDS_TARGET="kodi systemd"
PKG_DEPENDS_UNPACK="kodi"
PKG_LONGDESC="This package configures and modifies TinkerELEC for my specific usecase."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/kodi/addons/peripheral.joystick/resources/buttonmaps/xml/linux/
  cp -a ${PKG_DIR}/files/*.xml ${INSTALL}/usr/share/kodi/addons/peripheral.joystick/resources/buttonmaps/xml/linux/
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/usr/config
  cp -PR ${PKG_DIR}/config/* ${INSTALL}/usr/config

  mkdir -p ${INSTALL}/etc/ssh/ssh_config.d
  cp ${PKG_DIR}/ssh_config.d/*.conf ${INSTALL}/etc/ssh/ssh_config.d
}
