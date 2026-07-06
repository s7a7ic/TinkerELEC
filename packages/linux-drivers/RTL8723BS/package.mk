# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="RTL8723BS"
PKG_VERSION="bd0641826ff9d6efae506c4413d1fc15391fa886"
PKG_SHA256="9e3fb26aaae0505187c9cb535eb0adc635105bc91fe517921f8ac420ca6dc391"
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
