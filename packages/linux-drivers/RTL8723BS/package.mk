# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="RTL8723BS"
PKG_VERSION="031e0a4d8210f7c1d4d9a43153a53b9d892e4a53"
PKG_SHA256="5a92e1a883d1577bc67585302eddc57c64c83c8a2642bfc963ce10c32ee4b696"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/s7a7ic/rockchip_wlan"
PKG_URL="https://github.com/s7a7ic/rockchip_wlan/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="Realtek RTL8723BS Linux driver"
PKG_IS_KERNEL_PKG="yes"
PKG_DEPENDS_TARGET="autotools:host gcc:host linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_TOOLCHAIN="manual"

make_target() {
  kernel_make V=1 -C $(kernel_path) M="${PKG_BUILD}/rtl8723bs"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtl8723bs
  cp ${PKG_BUILD}/rtl8723bs/*.ko ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtl8723bs
}

#post_makeinstall_target() {
#  mkdir -p ${INSTALL}/usr/config
#  cp -PR ${PKG_DIR}/config/modprobe.d ${INSTALL}/usr/config
#}
