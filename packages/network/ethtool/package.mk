# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ethtool"
PKG_VERSION="6.14"
PKG_SHA256="9338bb00e492878d3bbe3cd2894e60db35813634c208db0b20f5c7ee84da69b1"
PKG_LICENSE="GPL"
PKG_SITE="https://www.kernel.org/pub/software/network/ethtool/"
PKG_URL="https://www.kernel.org/pub/software/network/ethtool/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libmnl"
PKG_LONGDESC="Ethtool is used for querying settings of an ethernet device and changing them."
PKG_BUILD_FLAGS="-cfg-libs"
