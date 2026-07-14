# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="rtw88-rtl8723bs"
PKG_VERSION="f5d1216c6f018bf7a94df958f435305528930617"
PKG_SHA256="46c1b201a8500cf8063e9f8bcdc3016e1205d7d11bc264843e1bbcf0da8e457e"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/MocLG/rtw88-rtl8723bs"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="rtw88 driver for the Realtek RTL8723BS"
PKG_IS_KERNEL_PKG="yes"
PKG_DEPENDS_TARGET="autotools:host gcc:host linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_TOOLCHAIN="manual"

make_target() {
  kernel_make V=1 -C $(kernel_path) M="${PKG_BUILD}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtw88
  cp ${PKG_BUILD}/rtw_8723x.ko ${PKG_BUILD}/rtw_8723b.ko ${PKG_BUILD}/rtw_8723bs.ko \
    ${PKG_BUILD}/rtw_core.ko ${PKG_BUILD}/rtw_sdio.ko \
    ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtw88

  mkdir -p ${INSTALL}/$(get_kernel_overlay_dir)/lib/firmware/rtw88/
    cp -av ${PKG_BUILD}/firmware/rtw8723b_*.bin ${INSTALL}/$(get_kernel_overlay_dir)/lib/firmware/rtw88/
}
