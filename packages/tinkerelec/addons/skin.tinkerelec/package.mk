PKG_NAME="skin.tinkerelec"
PKG_VERSION="1.0"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_UNPACK="kodi"
PKG_LONGDESC="Kodi Mediacenter modified Estuary theme."
PKG_TOOLCHAIN="manual"
PKG_IS_ADDON="yes"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/source
  if [ -e $(get_install_dir kodi)/.noinstall ]; then
    cp -a $(get_install_dir kodi)/.noinstall/skin.estuary/* ${ADDON_BUILD}/${PKG_ADDON_ID}/
  else
    cp -a $(get_build_dir kodi)/addons/skin.estuary/* ${ADDON_BUILD}/${PKG_ADDON_ID}/
  fi

  for patch in ${PKG_DIR}/patches/*; do
    patch -d ${ADDON_BUILD}/${PKG_ADDON_ID} -p1 < ${patch}
  done
}
