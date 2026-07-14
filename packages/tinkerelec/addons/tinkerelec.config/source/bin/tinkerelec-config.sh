#!/bin/sh

. /etc/profile
oe_setup_addon script.tinkerelec.config

function iterateFiles {
  for file in "${1}"/*; do
    [ -f "${file}" ] && echo "${file}"
    [ -d "${file}" ] && iterateFiles "${file}"
  done
}

function copyConfig {
  fileList=$(iterateFiles ${1})

  for file in $fileList; do
    local source=${file}
    local target=${2}/${file#${1}/} # add filepath to target without source path

    if [[ ! -e ${target} && ! -L ${target} ]]; then
      # create target_dir if it doesn't exist
      local target_dir=$(dirname ${target})
      [ ! -e ${target_dir} ] && mkdir -p ${target_dir}
      # copy file as its not existing in target
      cp -a ${source} ${target}
    else
      if [ $(sha1sum ${target} | cut -d ' ' -f 1) != $(sha1sum ${source} | cut -d ' ' -f 1) ]; then
        # overwrite file when its different
        cp -a ${source} ${target}
      fi
    fi
  done
}

function install_oemsplash() {
  if [ -e ${1} ]; then
    mount -o remount,rw /flash
    cp ${1} /flash/oemsplash.png
    mount -o remount,ro /flash
  fi
}

function create_script_link() {
  [ -z ${2} ] && target=$(basename ${1}) || target=${2}
  [ -e ${1} -a ! -e ${HOME}/.config/${target} ] && ln -s ${1} ${HOME}/.config/${target}
}

case "$1" in
  files)
    copyConfig ${ADDON_DIR}/libreelec_config/config ${HOME}/.config
    copyConfig ${ADDON_DIR}/kodi_config/buttonmaps ${HOME}/.kodi/userdata/addon_data/peripheral.joystick/resources/buttonmaps/xml/linux
    copyConfig ${ADDON_DIR}/kodi_config/keymaps ${HOME}/.kodi/userdata/keymaps
    chmod +x ${HOME}/.config/scripts/*.sh

    ADDON_SPLASH=${ADDON_DIR}/libreelec_config/oemsplash.png
    if [ -e ${ADDON_SPLASH} ]; then
      if [ -e /flash/oemsplash.png ]; then
        [ $(sha1sum /flash/oemsplash.png | cut -d ' ' -f 1) != $(sha1sum ${ADDON_SPLASH} | cut -d ' ' -f 1) ] && \
          install_oemsplash ${ADDON_SPLASH}
      else
        install_oemsplash ${ADDON_SPLASH}
      fi
    fi

    create_script_link ${HOME}/.config/scripts/autostart.sh
    create_script_link ${HOME}/.config/scripts/autostop.sh
    create_script_link ${HOME}/.config/scripts/shutdown.sh

    [ ! -e ${HOME}/.config/handle_ir ] && mkdir -p ${HOME}/.config/handle_ir || rm ${HOME}/.config/handle_ir/*
    create_script_link ${HOME}/.config/scripts/handle_ir.sh handle_ir/inhibit
    create_script_link ${HOME}/.config/scripts/handle_ir.sh handle_ir/power
  ;;

  profile)
    export curl_url
    export inhibit_seconds
    export ping_host
    [ "${shell_history}" = "false" ] && export histfile=/dev/null || export export histfile=$HOME/.ash_history
    export wake_time

    envsubst < ${ADDON_DIR}/libreelec_config/profile.template > ${HOME}/.profile
  ;;
esac
