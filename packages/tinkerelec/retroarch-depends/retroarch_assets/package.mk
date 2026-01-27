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
  mkdir -p ${INSTALL}/etc/fonts/conf.d
  cp -v ${PKG_DIR}/conf.d/*.conf ${INSTALL}/etc/fonts/conf.d

  # Remove unnecessary files
  for PKG_ASSET_FILES in \
    branding ctr fonts nxrgui README.md scripts wallpapers
  do
    safe_remove ${INSTALL}/usr/share/retroarch/assets/${PKG_ASSET_FILES}
  done 
}
