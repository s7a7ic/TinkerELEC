# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="RTL8723BS"
PKG_VERSION="039171be4d77252f8087439a340cf90fcf679e31"
PKG_SHA256="cbbef09acf8f9af56eb2ee7f7cce33abe619cee53716326f058e786f51691dc2"
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

post_makeinstall_target() {
  mkdir -p ${INSTALL}/usr/config
  cp -PR ${PKG_DIR}/config/modprobe.d ${INSTALL}/usr/config
}
