# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="btop"
PKG_VERSION="v1.4.5"
PKG_SHA256="0ffe03d3e26a3e9bbfd5375adf34934137757994f297d6b699a46edd43c3fc02"
PKG_LICENSE="Apache-2.0"
PKG_SITE="https://github.com/aristocratos/btop"
PKG_URL="https://github.com/aristocratos/btop/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Resource monitor that shows usage and stats for processor, memory, disks, network and processes."
PKG_TOOLCHAIN="cmake"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/local/share/btop/themes

  cp ${PKG_BUILD}/themes/* ${INSTALL}/usr/local/share/btop/themes
  cp ${PKG_BUILD}/.${TARGET_NAME}/btop ${INSTALL}/usr/bin/btop

  chmod 755 ${INSTALL}/usr/bin/btop
}
