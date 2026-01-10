# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="retroarch_assets"
PKG_VERSION="a7b711dfd74871e9985ba3b2fe2c15048a928aaf"
PKG_SHA256="b8d556c60d6e4432f8c83a78415c691d250718241bd164cbd949551df53cc107"
PKG_LICENSE="CC-BY-4.0"
PKG_SITE="https://github.com/libretro/retroarch-assets"
PKG_URL="https://github.com/libretro/retroarch-assets/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="gcc:host"
PKG_LONGDESC="RetroArch assets. Background and icon themes for the menu drivers."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  make -C ${PKG_BUILD} install INSTALLDIR="${INSTALL}/usr/share/retroarch/assets"
}

post_makeinstall_target() {
  # Remove unnecessary files
  for PKG_ASSET_FILES in \
    Automatic branding cfg ctr devtools FlatUX fonts nxrgui README.md scripts Systematic wallpapers
  do
    safe_remove ${INSTALL}/usr/share/retroarch/assets/${PKG_ASSET_FILES}
  done 
}
