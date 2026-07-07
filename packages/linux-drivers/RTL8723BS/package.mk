# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="RTL8723BS"
PKG_VERSION="71ef48440677ad072aa1e7728a3410edcbdf9b97"
PKG_SHA256="da46ebe16fa11eb2f5705a3ea2f717b7ba3d7894e3e62cf4f0555d5cb37b122c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/s7a7ic/rtl8723bs_linux_driver"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="Realtek RTL8723BS Linux driver"
PKG_IS_KERNEL_PKG="yes"
PKG_DEPENDS_TARGET="autotools:host gcc:host linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+lto"

make_target() {
  kernel_make V=1 -C $(kernel_path) M="${PKG_BUILD}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtl8723bs
  cp ${PKG_BUILD}/*.ko ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/wireless/realtek/rtl8723bs
}
