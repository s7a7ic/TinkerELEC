# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="RTL8723BS"
PKG_VERSION="5a3f3ee2edd6cd67276b01553ef3f221c5930eca"
PKG_SHA256="1ba77ebff7e34eb0bf8666a533ee33929d8b4da564c2aaa901a0d5a565f6dbee"
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
