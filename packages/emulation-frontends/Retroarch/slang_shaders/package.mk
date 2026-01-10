PKG_NAME="slang_shaders"
PKG_VERSION="c2f3c5b0ce8c5e7e3ed9d885a924f85712cb38a0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/slang-shaders"
PKG_URL="${PKG_SITE}.git"
PKG_LONGDESC="Common Slang shaders for RetroArch"
PKG_TOOLCHAIN="manual"
GET_HANDLER_SUPPORT="git"

makeinstall_target() {
  make -C ${PKG_BUILD} install INSTALLDIR="${INSTALL}/usr/share/retroarch/shaders/Vulkan-Shaders"
}
