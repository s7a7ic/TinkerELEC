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
    local target=${2}/${file#${1}/} # add config filepath to target_dir

    if [[ ! -e ${target} && ! -L ${target} ]]; then
      local target_dir=$(dirname ${target})
      if [ ! -e ${target_dir} ]; then
        echo "C DIR ${target_dir}"
        mkdir -p ${target_dir}
      fi
      echo "C NEW ${target}"
      cp -a ${source} ${target}
    else
      # TODO: handle link "cp -a?"
      if [ $(sha1sum ${target} | cut -d ' ' -f 1) != $(sha1sum ${source} | cut -d ' ' -f 1) ]; then
        echo "C DIFF ${target}"
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
  [ -e ${1} -a ! -e /storage/.config/${target} ] && ln -s ${1} /storage/.config/${target}
}

case "$1" in
  files)
    copyConfig ${ADDON_DIR}/libreelec_config/config /storage/.config
    copyConfig ${ADDON_DIR}/kodi_config/buttonmaps /storage/.kodi/userdata/addon_data/peripheral.joystick/resources/buttonmaps/xml/linux
    copyConfig ${ADDON_DIR}/kodi_config/keymaps /storage/.kodi/userdata/keymaps
    chmod +x /storage/.config/scripts/*.sh

    ADDON_SPLASH=${ADDON_DIR}/libreelec_config/oemsplash.png
    if [ -e ${ADDON_SPLASH} ]; then
      if [ -e /flash/oemsplash.png ]; then
        [ $(sha1sum /flash/oemsplash.png | cut -d ' ' -f 1) != $(sha1sum ${ADDON_SPLASH} | cut -d ' ' -f 1) ] && \
          install_oemsplash ${ADDON_SPLASH}
      else
        install_oemsplash ${ADDON_SPLASH}
      fi
    fi

    create_script_link /storage/.config/scripts/autostart.sh
    create_script_link /storage/.config/scripts/autostop.sh
    create_script_link /storage/.config/scripts/shutdown.sh

    [ ! -e /storage/.config/handle_ir ] && mkdir -p /storage/.config/handle_ir || rm /storage/.config/handle_ir/*
    create_script_link /storage/.config/scripts/handle_ir.sh handle_ir/inhibit
    create_script_link /storage/.config/scripts/handle_ir.sh handle_ir/power
  ;;

  profile)
    export curl_url
    export inhibit_seconds
    export ping_host
    [ "${shell_history}" = "false" ] && export histfile=/dev/null || export export histfile=$HOME/.ash_history
    export wake_time

    envsubst < ${ADDON_DIR}/libreelec_config/profile.template > /storage/.profile
  ;;
esac
