# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="media-driver"
PKG_VERSION="25.2.2"
PKG_SHA256="21937b289a094c6ddee65c66a4c35ec35fa980a2548bf17ccebe79a5febd3ee4"
PKG_ARCH="x86_64"
PKG_LICENSE="MIT"
PKG_SITE="https://01.org/linuxmedia"
PKG_URL="https://github.com/intel/media-driver/archive/intel-media-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libva libdrm gmmlib"
PKG_LONGDESC="media-driver: The Intel(R) Media Driver for VAAPI is a new VA-API (Video Acceleration API) user mode driver supporting hardware accelerated decoding, encoding, and video post processing for GEN based graphics hardware."

pre_configure_target() {
  # build with gcc 15 (since 15-20250330, build is successful with 15-20250316) fails
  # unless this error is degraded to a warning
  export CXXFLAGS+=" -Wno-error=array-bounds="
}

PKG_CMAKE_OPTS_TARGET="-DBUILD_CMRTLIB=OFF \
                       -DBUILD_KERNELS=ON \
                       -DBUILD_TYPE=release \
                       -DENABLE_NONFREE_KERNELS=ON \
                       -DMEDIA_BUILD_FATAL_WARNINGS=ON \
                       -DMEDIA_RUN_TEST_SUITE=OFF"
