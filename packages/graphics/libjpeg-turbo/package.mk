# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libjpeg-turbo"
PKG_VERSION="3.1.0"
PKG_SHA256="35fec2e1ddfb05ecf6d93e50bc57c1e54bc81c16d611ddf6eff73fff266d8285"
PKG_LICENSE="GPL"
PKG_SITE="https://libjpeg-turbo.org/"
PKG_URL="https://github.com/libjpeg-turbo/libjpeg-turbo/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="cmake:host ninja:host"
PKG_DEPENDS_TARGET="cmake:host ninja:host gcc:host"
PKG_LONGDESC="A JPEG image codec that uses SIMD instructions."
PKG_BUILD_FLAGS="+pic +pic:host"

PKG_CMAKE_OPTS_HOST="-DENABLE_STATIC=ON \
                     -DENABLE_SHARED=OFF \
                     -DWITH_JPEG8=ON \
                     -DWITH_SIMD=OFF"

PKG_CMAKE_OPTS_TARGET="-DENABLE_STATIC=ON \
                       -DENABLE_SHARED=OFF \
                       -DWITH_JPEG8=ON"

if target_has_feature "(neon|sse)"; then
  PKG_CMAKE_OPTS_TARGET+=" -DWITH_SIMD=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DWITH_SIMD=OFF"
fi

if [ ${TARGET_ARCH} = "x86_64" ]; then
  PKG_DEPENDS_HOST+=" nasm:host"
  PKG_DEPENDS_TARGET+=" nasm:host"
fi

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin
}
