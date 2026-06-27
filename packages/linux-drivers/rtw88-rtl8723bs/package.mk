# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="rtw88-rtl8723bs"
PKG_VERSION="efd7f8d404dcc01b302e3bdf1443d8ec65f61d5e"
PKG_SHA256="6516c9c40e4ad3796c5b3177cb8a368d1c8cf96f23a2c698c67923dda72d3a84"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MocLG/rtw88-rtl8723bs"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="Realtek RTL8723BS Linux driver"
PKG_IS_KERNEL_PKG="yes"
PKG_DEPENDS_TARGET="autotools:host gcc:host linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_TOOLCHAIN="manual"

make_target() {
  kernel_make V=1 -C $(kernel_path) M="${PKG_BUILD}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtw88
  cp ${PKG_BUILD}/rtw_8723*.ko ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtw88
  cp ${PKG_BUILD}/rtw_core.ko ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtw88
  cp ${PKG_BUILD}/rtw_sdio.ko ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtw88
  mkdir -p ${INSTALL}/$(get_kernel_overlay_dir)/lib/firmware/rtw88/
    cp -av ${PKG_BUILD}/firmware/rtw8723b_*.bin ${INSTALL}/$(get_kernel_overlay_dir)/lib/firmware/rtw88/
}
