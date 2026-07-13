# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="rtw88-rtl8723bs"
PKG_VERSION="d74a40c3e18f35f91691a509ec21a78a086ddba3"
PKG_SHA256="a349a235addc6d76e817e9f43dfd63138ca5eb09e6c6912f2d952a1551b4da5a"
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
}
