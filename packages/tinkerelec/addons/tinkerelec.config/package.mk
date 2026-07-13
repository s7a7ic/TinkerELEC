# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="tinkerelec.config"
PKG_VERSION="1.0"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/s7a7ic/TinkerELEC-Project"
PKG_URL=""
PKG_DEPENDS_UNPACK="tinkerelec-project"
PKG_SHORTDESC="TinkerELEC system configuration"
PKG_LONGDESC="This package configures LibreELEC for my specific use-case."
PKG_SECTION="script"
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="TinkerELEC Config"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROJECTS="RK3288 TinkerBoard"
#PKG_PROVIDES="executable"
PKG_MAINTAINER="s7a7ic"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}

  PROJECT_DIR=$(get_build_dir tinkerelec-project)
  cp -a ${PROJECT_DIR}/kodi_config ${PROJECT_DIR}/libreelec_config ${ADDON_BUILD}/${PKG_ADDON_ID}
}
