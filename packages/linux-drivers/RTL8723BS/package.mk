# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="RTL8723BS"
PKG_VERSION="d3b3feee8eb342fca5c885f17ff2a84275461438"
PKG_SHA256="acc4bba28d2d1da9aab931e8318cd0a903590b05714e528ea73841fe9bc5962f"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/s7a7ic/rockchip_wlan"
PKG_URL="https://github.com/s7a7ic/rockchip_wlan/archive/${PKG_VERSION}.tar.gz"
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
