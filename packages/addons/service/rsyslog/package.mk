# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rsyslog"
PKG_VERSION="8.2504.0"
PKG_SHA256="5092a20ed40987c74cc604ebfcd6c749e47eb9fc34adc1c2637e6553e7f047ab"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rsyslog"
PKG_URL="https://www.rsyslog.com/files/download/rsyslog/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain curl libestr libfastjson libgcrypt liblogging liblognorm librelp util-linux zlib"
PKG_SECTION="service"
PKG_SHORTDESC="Rsyslog: a rocket-fast system for log processing."
PKG_LONGDESC="Rsyslog (${PKG_VERSION}) offers high-performance, great security features and a modular design."
PKG_BUILD_FLAGS="-sysroot"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Rsyslog"
PKG_ADDON_TYPE="xbmc.service"

PKG_CONFIGURE_OPTS_TARGET="--disable-default-tests \
                           --enable-imfile \
                           --enable-imjournal \
                           --enable-relp \
                           --enable-omjournal \
                           ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes"

export LIBGCRYPT_CONFIG="${SYSROOT_PREFIX}/usr/bin/libgcrypt-config"

pre_configure_target() {
  CFLAGS+=" -fcommon"
}

post_configure_target() {
  libtool_remove_rpath libtool
}

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp ${PKG_INSTALL}/usr/sbin/rsyslogd \
     ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/

  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/rsyslog
  for l in $(find ${PKG_INSTALL}/usr/lib -name *.so); do
    cp ${l} ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/rsyslog/
  done
}
