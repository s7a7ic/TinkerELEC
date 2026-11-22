# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="tinkerelec.config"
PKG_VERSION="1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="tinkerelec-nespi-dtb"
PKG_SITE="https://github.com/s7a7ic/TinkerELEC-Project"
PKG_DEPENDS_UNPACK="tinkerelec-project"
PKG_SECTION="script"
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="TinkerELEC Config"
PKG_ADDON_PROJECTS="RK3288 TinkerBoard"
PKG_MAINTAINER="s7a7ic"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/dtb

  local PROJECT_DIR=$(get_build_dir tinkerelec-project)
  cp -a ${PROJECT_DIR}/kodi_config ${PROJECT_DIR}/libreelec_config ${ADDON_BUILD}/${PKG_ADDON_ID}

  cp $(get_build_dir tinkerelec-nespi-dtb)/rk3288-tinker-s-nespi.* \
    ${ADDON_BUILD}/${PKG_ADDON_ID}/dtb/
}
