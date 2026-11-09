PKG_NAME="rtl8723bs-driver"
PKG_VERSION="1.0"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="toolchain RTL8723BS rtw88-rtl8723bs"
PKG_SECTION="script"
PKG_SHORTDESC="WiFi driver selector for the Realtek RTL8723BS"
PKG_LONGDESC="This Addon includes WiFi drivers for the Realtek RTL8723BS and gives the possibility to select which kernel module to use."
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="RTL8723BS Driver Selector"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROJECTS="RK3288 TinkerBoard"
PKG_PROVIDES="executable"
PKG_MAINTAINER="s7a7ic"
PKG_IS_KERNEL_PKG="yes"

KVER="6.16.12"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/kernel-overlay/lib/modules/${KVER}/kernel/drivers/net/wireless/realtek/{rtw88,rtl8723bs}

  # copy RTL8723BS module file
  cp $(get_build_dir RTL8723BS)/8723bs.ko \
    ${ADDON_BUILD}/${PKG_ADDON_ID}/kernel-overlay/lib/modules/${KVER}/kernel/drivers/net/wireless/realtek/rtl8723bs/

  # copy rtw88-rtl8723bs module and firmware files
  RTW88_DIR=$(get_build_dir rtw88-rtl8723bs)
  cp ${RTW88_DIR}/rtw_8723x.ko ${RTW88_DIR}/rtw_8723b.ko ${RTW88_DIR}/rtw_8723bs.ko \
    ${RTW88_DIR}/rtw_core.ko ${RTW88_DIR}/rtw_sdio.ko \
    ${ADDON_BUILD}/${PKG_ADDON_ID}/kernel-overlay/lib/modules/${KVER}/kernel/drivers/net/wireless/realtek/rtw88/
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/kernel-overlay/lib/firmware/rtw88
    cp -av ${RTW88_DIR}/firmware/rtw8723b_*.bin ${ADDON_BUILD}/${PKG_ADDON_ID}/kernel-overlay/lib/firmware/rtw88/
}

# add default configuration if it's build as an image dependency
post_install() {
  mkdir -p ${INSTALL}/usr/config/modprobe.d
    cp ${PKG_DIR}/files/rtl8723bs-driver.conf ${INSTALL}/usr/config/modprobe.d/
  mkdir -p ${INSTALL}/usr/cache/kernel-overlays
    cp ${PKG_DIR}/files/rtl8723bs-overlay.conf ${INSTALL}/usr/cache/kernel-overlays/
}
