# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="open-vm-tools"
PKG_VERSION="12.5.2"
PKG_SHA256="45fe43982e618f52a6b12c7578d9c6b63e36de62d23034a3852267b1aa5bb9ab"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vmware/open-vm-tools"
PKG_URL="https://github.com/vmware/open-vm-tools/releases/download/${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}-24697584.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse3 glib libdnet libtirpc"
PKG_LONGDESC="open-vm-tools: open source implementation of VMware Tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-docs \
                           --disable-tests \
                           --disable-containerinfo \
                           --disable-deploypkg \
                           --without-pam \
                           --without-gtk2 \
                           --without-gtkmm \
                           --without-ssl \
                           --without-x \
                           --without-icu \
                           --without-kernel-modules \
                           --with-fuse=fuse3 \
                           --with-udev-rules-dir=/usr/lib/udev/rules.d/ \
                           --with-sysroot=${SYSROOT_PREFIX}"

post_unpack() {
  # Hack to allow package to be bumped without linking against old libraries
  rm -f ${SYSROOT_PREFIX}/usr/lib/libvmtools*
}

pre_configure_target() {
  export LIBS="-ldnet -ltirpc"
}

post_configure_target() {
  libtool_remove_rpath libtool
}

post_makeinstall_target() {
  rm -rf ${INSTALL}/sbin
  rm -rf ${INSTALL}/usr/share
  rm -rf ${INSTALL}/etc/vmware-tools/scripts/vmware/network

  chmod -x ${INSTALL}/usr/lib/udev/rules.d/*.rules

  find ${INSTALL}/etc/vmware-tools/ -type f | xargs sed -i '/.*expr.*/d'
}

post_install() {
  enable_service vmtoolsd.service
  enable_service vmware-vmblock-fuse.service
}
