# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="screensaver.biogenesis"
PKG_VERSION="22.0.2-Piers"
PKG_SHA256="acb3e0c7885e4a0f766403d9c58e540ea09c75cf8926a83ba24bad725ad755d0"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/xbmc/screensaver.biogenesis"
PKG_URL="https://github.com/xbmc/screensaver.biogenesis/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_SECTION=""
PKG_SHORTDESC="screensaver.biogenesis"
PKG_LONGDESC="screensaver.biogenesis"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.ui.screensaver"

if [ "${OPENGL}" = "no" ]; then
  exit 0
fi
