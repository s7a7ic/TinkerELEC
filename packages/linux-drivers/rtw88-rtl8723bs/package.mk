# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="rtw88-rtl8723bs"
PKG_VERSION="c6ea9993949fbe98b03d27567160cd85a0c4265e"
PKG_SHA256="e19c9d2eb3f9637315b8d8340f737e9cce73dbb9f8f01ff0017dbc33fc3b5251"
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
  cp ${PKG_BUILD}/rtw_8723x.ko ${PKG_BUILD}/rtw_8723b.ko ${PKG_BUILD}/rtw_8723bs.ko \
    ${PKG_BUILD}/rtw_core.ko ${PKG_BUILD}/rtw_sdio.ko \
    ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtw88
  mkdir -p ${INSTALL}/$(get_kernel_overlay_dir)/lib/firmware/rtw88/
    cp -av ${PKG_BUILD}/firmware/rtw8723b_*.bin ${INSTALL}/$(get_kernel_overlay_dir)/lib/firmware/rtw88/
}
