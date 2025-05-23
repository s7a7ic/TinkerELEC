# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libmediainfo"
PKG_VERSION="25.04"
PKG_SHA256="ad45ed7c9db7807aa803845ca88bad9526aa8da883a58127e5390aaa2d81bbb1"
PKG_LICENSE="GPL"
PKG_SITE="https://mediaarea.net/en/MediaInfo/Download/Source"
PKG_URL="https://mediaarea.net/download/source/libmediainfo/${PKG_VERSION}/libmediainfo_${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libzen zlib"
PKG_DEPENDS_CONFIG="libzen"
PKG_LONGDESC="MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="-sysroot"

configure_target() {
  cd Project/GNU/Library
  do_autoreconf
  ./configure \
        --host=${TARGET_NAME} \
        --build=${HOST_NAME} \
        --enable-static \
        --enable-shared \
        --prefix=/usr \
        --enable-visibility
}

make_target() {
  make
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/include/MediaInfo ${INSTALL}/usr/lib/pkgconfig
  cp -aP ../../../Source/MediaInfo/*.h ${INSTALL}/usr/include/MediaInfo
  for i in Archive Audio Duplicate Export Image Multiple Reader Tag Text Video; do
    mkdir -p ${INSTALL}/usr/include/MediaInfo/${i}/
    cp -aP ../../../Source/MediaInfo/${i}/*.h ${INSTALL}/usr/include/MediaInfo/${i}/
  done

  # only install static library, so mediainfo does not build with shared library
  cp -P .libs/libmediainfo.a ${INSTALL}/usr/lib
  cp -P libmediainfo.pc ${INSTALL}/usr/lib/pkgconfig
}
