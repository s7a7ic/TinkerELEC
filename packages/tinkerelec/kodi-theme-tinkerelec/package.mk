PKG_NAME="kodi-theme-tinkerelec"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="kodi"
PKG_DEPENDS_UNPACK="kodi"
PKG_LONGDESC="Kodi Mediacenter modified Estuary theme."
PKG_TOOLCHAIN="manual"

SKIN_NAME="skin.tinkerelec"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/kodi/addons/
  cp -a $(get_install_dir kodi)/.noinstall/skin.estuary ${INSTALL}/usr/share/kodi/addons/${SKIN_NAME}

  for patch in ${PKG_DIR}/files/*; do
    patch -d ${INSTALL}/usr/share/kodi/addons/${SKIN_NAME} -p1 < ${patch}
  done
}
