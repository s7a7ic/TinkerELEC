# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2025-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="plymouth-lite"
PKG_VERSION="9e2ff28ea32e8ab0410435d25e198136e6ad82dc"
PKG_SHA256="1efbcf4758795791e45bf3512c44bf5898acd6072369189ffbdbb07f470156e8"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/sailfishos/plymouth-lite"
PKG_URL="https://github.com/sailfishos/plymouth-lite/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_INIT="toolchain gcc:init libpng"
PKG_LONGDESC="Boot splash screen based on Fedora's Plymouth code"

pre_configure_init() {
  # plymouth-lite dont support to build in subdirs
  cd ${PKG_BUILD}
    rm -rf .${TARGET_NAME}-init
}

makeinstall_init() {
  mkdir -p ${INSTALL}/usr/bin
    cp ply-image ${INSTALL}/usr/bin

  mkdir -p ${INSTALL}/splash
    find_file_path splash/splash.conf && cp ${FOUND_PATH} ${INSTALL}/splash
    find_file_path "splash/splash-*.png" && cp ${FOUND_PATH} ${INSTALL}/splash
}
