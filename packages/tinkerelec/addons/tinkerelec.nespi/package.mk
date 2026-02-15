PKG_NAME="tinkerelec.nespi"
PKG_VERSION="1.0"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_SECTION="script"
PKG_SHORTDESC="TinkerELEC: Manage DTB file for the NesPi+ Case"
PKG_LONGDESC="Install, update or remove the patched DTB file for the NesPi+ Case, which includes support for front panel buttons and IR receiver."
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="NesPi+ DTB"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROJECTS="RK3288 TinkerBoard"
PKG_PROVIDES="executable"
PKG_MAINTAINER="s7a7ic"

make_target() {
  cd $(get_build_dir linux)

  for patch in ${PKG_DIR}/patches/*; do
    patch -d $(get_build_dir linux) -p1 < ${patch}
  done

  # build dtb
  DTC_FLAGS=-@ kernel_make rockchip/rk3288-tinker-s.dtb
}

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/{bin,dtb}

  cp $(get_build_dir linux)/arch/arm/boot/dts/rockchip/rk3288-tinker-s.dtb ${ADDON_BUILD}/${PKG_ADDON_ID}/dtb/rk3288-tinker-s-nespi.dtb

  # save sha256sum for *.dtb file
  sha256sum ${ADDON_BUILD}/${PKG_ADDON_ID}/dtb/rk3288-tinker-s-nespi.dtb | sed 's, .*/, ,' > \
  ${ADDON_BUILD}/${PKG_ADDON_ID}/dtb/rk3288-tinker-s-nespi.dtb.sha256
}
