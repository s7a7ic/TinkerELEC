# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="RTL8723BS"
PKG_VERSION="b514f67b26318548532e68273b6e9a271175cf6d"
PKG_SHA256="4b829678bf79b884920eec566c38e02990f1d2f6374c78cc4de407047a739b37"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/s7a7ic/rtl8723bs_linux_driver"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="Realtek RTL8723BS Linux driver"
PKG_IS_KERNEL_PKG="yes"
PKG_DEPENDS_TARGET="autotools:host gcc:host linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+lto"

make_target() {
  kernel_make V=1 -C $(kernel_path) M="${PKG_BUILD}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtl8723bs
  cp ${PKG_BUILD}/*.ko ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtl8723bs
}
