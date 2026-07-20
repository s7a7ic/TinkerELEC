# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="rtw88-rtl8723bs"
PKG_VERSION="83ef349853605930234be655f527be5993ec64a6"
PKG_SHA256="122b3536eb69e291ab91d5a1c2412d32b6b9b6c9e4c54e6c7c5ef10982f6465f"
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
