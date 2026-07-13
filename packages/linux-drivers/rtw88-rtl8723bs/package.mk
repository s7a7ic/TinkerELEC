# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="rtw88-rtl8723bs"
PKG_VERSION="4a9b9c94b0f7e98a5045e9764245abfb91c448d3"
PKG_SHA256="9c5687c763d190cdb7c76f00a4fdf22ae7459f256c3b71988e645d9b27593df5"
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
