# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="RTL8723BS"
PKG_VERSION="d97ddf7c1ae0faf316cca57cc0856cf28d7d9370"
PKG_SHA256="ec9048cadd91520f75bb56cac05e75df87e18938e47fb51f128bed4433225a27"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Lebensgefahr/rockchip_wlan"
PKG_URL="https://github.com/Lebensgefahr/rockchip_wlan/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="Realtek RTL8723BS Linux driver"
PKG_IS_KERNEL_PKG="yes"
PKG_DEPENDS_TARGET="autotools:host gcc:host linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_TOOLCHAIN="manual"

make_target() {
  kernel_make V=1 -C $(kernel_path) M="${PKG_BUILD}/rtl8723bs"
}

makeinstall_target() {
  cd ${PKG_BUILD}/rtl8723bs
  mkdir -p ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtl8723bs
    cp *.ko ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtl8723bs
}
