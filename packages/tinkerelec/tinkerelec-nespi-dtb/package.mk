# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="tinkerelec-nespi-dtb"
PKG_VERSION="1.0"
PKG_LICENSE="GPLv2"
PKG_MAINTAINER="s7a7ic"
PKG_SITE="https://github.com/s7a7ic/TinkerELEC-Project"
PKG_LONGDESC="This package builds a patched rk3288-tinker-s.dtb file."
PKG_DEPENDS_TARGET="toolchain linux"
PKG_TOOLCHAIN="manual"

make_target() {
  local KERNEL_DIR=$(get_build_dir linux)
  cd ${KERNEL_DIR}

  # backup un-patched file
  cp arch/arm/boot/dts/rockchip/rk3288-tinker.dtsi \
    arch/arm/boot/dts/rockchip/rk3288-tinker.dtsi.unpatched

  # apply patches
  for patch in ${PKG_DIR}/patches/*; do
    patch -d ${KERNEL_DIR} -p1 < ${patch}
  done

  # build dtb
  DTC_FLAGS=-@ kernel_make rockchip/rk3288-tinker-s.dtb

  # restore un-patched file
  mv arch/arm/boot/dts/rockchip/rk3288-tinker.dtsi.unpatched \
    arch/arm/boot/dts/rockchip/rk3288-tinker.dtsi

  cp ${KERNEL_DIR}/arch/arm/boot/dts/rockchip/rk3288-tinker-s.dtb \
    ${PKG_BUILD}/rk3288-tinker-s-nespi.dtb

  # save sha256sum for *.dtb file
  sha256sum ${PKG_BUILD}/rk3288-tinker-s-nespi.dtb | sed 's, .*/, ,' > \
    ${PKG_BUILD}/rk3288-tinker-s-nespi.dtb.sha256
}
