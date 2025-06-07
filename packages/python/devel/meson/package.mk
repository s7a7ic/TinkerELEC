# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="meson"
PKG_VERSION="1.8.1"
PKG_SHA256="b4e3b80e8fa633555abf447a95a700aba1585419467b2710d5e5bf88df0a7011"
PKG_LICENSE="Apache"
PKG_SITE="https://mesonbuild.com"
PKG_URL="https://github.com/mesonbuild/meson/releases/download/${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="Python3:host setuptools:host"
PKG_LONGDESC="High productivity build system"
PKG_TOOLCHAIN="python"

post_makeinstall_target() {
  # Avoid using full path to python3 that may exceed 128 byte limit.
  # Instead use PATH as we know our toolchain is first.
  sed -e '1 s/^#!.*$/#!\/usr\/bin\/env python3/' -i ${TOOLCHAIN}/bin/meson
}
