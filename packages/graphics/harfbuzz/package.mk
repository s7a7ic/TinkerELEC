# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="harfbuzz"
PKG_VERSION="11.2.1"
PKG_SHA256="093714c8548a285094685f0bdc999e202d666b59eeb3df2ff921ab68b8336a49"
PKG_LICENSE="GPL"
PKG_SITE="http://www.freedesktop.org/wiki/Software/HarfBuzz"
PKG_URL="https://github.com/harfbuzz/harfbuzz/releases/download/${PKG_VERSION}/harfbuzz-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain cairo freetype glib"
PKG_LONGDESC="HarfBuzz is an OpenType text shaping engine."

PKG_MESON_OPTS_TARGET="-Dbenchmark=disabled \
                       -Dcairo=enabled \
                       -Ddocs=disabled \
                       -Dfreetype=enabled \
                       -Dglib=enabled \
                       -Dgobject=disabled \
                       -Dgraphite=disabled \
                       -Dicu=disabled \
                       -Dtests=disabled"
