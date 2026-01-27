PKG_NAME="retroarch"
PKG_VERSION="v1.22.2"
PKG_SHA256="245ef18c8fa8fbd9fbb5eb25cf43e17c6aace2f95c1ed99873cbd794012bb232"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/RetroArch"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain freetype zlib ffmpeg libass libxkbcommon glsl_shaders slang_shaders systemd libpng fontconfig"
PKG_LONGDESC="Reference frontend for the libretro API."

PKG_CONFIGURE_OPTS_TARGET="--disable-vg \
                           --disable-sdl \
                           --disable-sdl2 \
                           --disable-ssl \
                           --disable-qt \
                           --disable-discord \
                           --disable-cheevos \
                           --enable-zlib \
                           --enable-freetype \
                           --enable-translate \
                           --enable-cdrom \
                           --enable-command \
                           --enable-kms \
                           --enable-egl \
                           --enable-ssl \
                           --enable-builtinmbedtls \
                           --datarootdir=${SYSROOT_PREFIX}/usr/share" # don't use host /usr/share!

PKG_MAKE_OPTS_TARGET="V=1 \
                      HAVE_HAVE_ZARCH=0 \
                      HAVE_WIFI=1 \
                      HAVE_BLUETOOTH=1 \
                      HAVE_CLOUDSYNC=1 \
                      HAVE_SSL=1 \
                      HAVE_BUILTINMBEDTLS=1 \
                      HAVE_FREETYPE=1 \
                      HAVE_CHEEVOS=0"

if [ "${PROJECT}" = "RPi" ]; then
  if [ "${DEVICE}" = "RPi3" -o "${DEVICE}" = "RPi4" -o "${DEVICE}" = "RPi5" ]; then
    PKG_MAKE_OPTS_TARGET+=" HAVE_RETROFLAG=1"
  fi
fi

if [ "${OPENGLES_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengles"
  if [ "${DEVICE:0:4}" =  "RPi4" ] || [ "${DEVICE:0:4}" = "RPi5" ] || [ "${DEVICE}" = "RK3288" ] || [ "${DEVICE}" = "RK3399" ] || [ "${PROJECT}" = "Generic" ] || [ "${DEVICE}" = "TinkerBoard" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengles3 \
                                 --enable-opengles3_1"
    if [ "${PROJECT}" = "Generic" ]; then
      PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengles3_2"
    fi
  fi
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-opengles"
fi

if [ "${OPENGL_SUPPORT}" = yes -a ! "${OPENGLES_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL}"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengl"
  PKG_MAKE_OPTS_TARGET+=" HAVE_OPENGL1=1"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-opengl"
fi

if [ "${VULKAN_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" ${VULKAN}"
  PKG_MAKE_OPTS_TARGET+=" HAVE_VULKAN=1"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-vulkan"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-vulkan"
fi

if [ "${DISPLAYSERVER}" != "no" ]; then
  PKG_DEPENDS_TARGET+=" ${DISPLAYSERVER}"
fi

if [ "${DISPLAYSERVER}" = "x11" ]; then
  PKG_DEPENDS_TARGET+=" libXxf86vm libXv"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-x11 --enable-xinerama"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-x11"
fi

if [ "${DISPLAYSERVER}" = "wl" ]; then
  PKG_DEPENDS_TARGET+=" wayland wayland-protocols"
  PKG_MAKE_OPTS_TARGET+=" HAVE_WAYLAND=1"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-wayland"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-wayland"
fi

if [ "${PULSEAUDIO_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" pulseaudio"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-pulse"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-pulse"
fi

if [ "${ALSA_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" alsa-lib"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-alsa"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-alsa"
fi

if [ "${PIPEWIRE_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" pipewire"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-pipewire"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-pipewire"
fi

if [[ "${TARGET_FPU}" =~ "neon" ]]; then
  if [ "${ARCH}" = "arm" ]; then
    PKG_CONFIGURE_OPTS+=" --enable-neon"
  fi
fi

if [ "${OPENGLES}" = "bcm2835-driver" ]; then
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-videocore --enable-dispmanx"
  PKG_CONFIGURE_OPTS_TARGET=${PKG_CONFIGURE_OPTS_TARGET//--enable-kms/--disable-kms}
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-videocore"
fi

pre_configure_target() {
  TARGET_CONFIGURE_OPTS=""
  cd ${PKG_BUILD}
}

pre_make_target() {
  if [ "${OPENGLES}" = "bcm2835-driver" ]; then
    CFLAGS+=" -I${SYSROOT_PREFIX}/usr/include/interface/vcos/pthreads \
              -I${SYSROOT_PREFIX}/usr/include/interface/vmcs_host/linux"
  fi
  CFLAGS=${CFLAGS/"-Os"/"-O2"}
  CFLAGS=${CFLAGS/"-O3"/"-O2"}
}

make_target() {
  make ${PKG_MAKE_OPTS_TARGET}
  make -C gfx/video_filters compiler=${CC} extra_flags="${CFLAGS}"
  make -C libretro-common/audio/dsp_filters compiler=${CC} extra_flags="${CFLAGS}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
    cp -v ${PKG_BUILD}/retroarch ${INSTALL}/usr/bin
#    cp -v ${PKG_DIR}/scripts/lakka-*.sh ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/share/video_filters
    cp -v ${PKG_BUILD}/gfx/video_filters/*.so ${INSTALL}/usr/share/video_filters
    cp -v ${PKG_BUILD}/gfx/video_filters/*.filt ${INSTALL}/usr/share/video_filters
  mkdir -p ${INSTALL}/usr/share/audio_filters
    cp -v ${PKG_BUILD}/libretro-common/audio/dsp_filters/*.so ${INSTALL}/usr/share/audio_filters
    cp -v ${PKG_BUILD}/libretro-common/audio/dsp_filters/*.dsp ${INSTALL}/usr/share/audio_filters
  mkdir -p ${INSTALL}/usr/lib/retroarch
#    cp -v ${PKG_DIR}/scripts/retroarch-config ${INSTALL}/usr/lib/retroarch

  # System overlay
  mkdir -p ${INSTALL}/usr/share/retroarch/system
    touch ${INSTALL}/usr/share/retroarch/system/.placeholder

  # General configuration
  mkdir -p ${INSTALL}/etc
  echo 'libretro_directory = "/tmp/cores"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'libretro_info_path = "/tmp/cores"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'rgui_browser_directory = "/storage/roms"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'content_database_path = "/tmp/database/rdb"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'playlist_directory = "/storage/playlists"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'savefile_directory = "/storage/savefiles"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'savestate_directory = "/storage/savestates"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'system_directory = "/tmp/system"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'screenshot_directory = "/storage/screenshots"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'video_shader_dir = "/tmp/shaders"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'rgui_show_start_screen = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'assets_directory = "/tmp/assets"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'overlay_directory = "/tmp/overlays"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'cheat_database_path = "/tmp/database/cht"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'cursor_directory = "/tmp/database/cursors"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'log_dir = "/storage/logfiles"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'recording_output_directory = "/storage/recordings"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'menu_driver = "xmb"' >> ${INSTALL}/etc/retroarch.cfg

  # Power settings
  # Use ondemand for all RPi devices (for backwards compatibility?)
  # and any battery powered device (OGA and RPi case)
  if [ "${PROJECT}" = "RPi" ] || [ "${DEVICE}" = "OdroidGoAdvance" ]; then
    echo 'cpu_main_gov = "ondemand"' >> ${INSTALL}/etc/retroarch.cfg
    echo 'cpu_menu_gov = "ondemand"' >> ${INSTALL}/etc/retroarch.cfg
    echo 'cpu_scaling_mode = "1"' >> ${INSTALL}/etc/retroarch.cfg
  fi

  # Quick menu
  echo 'core_assets_directory = "/storage/roms/downloads"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'quick_menu_show_undo_save_load_state = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'quick_menu_show_save_core_overrides = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'quick_menu_show_save_game_overrides = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'quick_menu_show_cheats = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'quick_menu_show_overlays = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'quick_menu_show_rewind = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'quick_menu_show_latency = "false"' >> ${INSTALL}/etc/retroarch.cfg

  # Video
  echo 'video_windowed_fullscreen = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'video_smooth = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'video_aspect_ratio_auto = "true"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'video_threaded = "true"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'video_font_path = "/tmp/assets/xmb/monochrome/font.ttf"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'video_font_size = "32"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'video_filter_dir = "/usr/share/video_filters"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'video_gpu_screenshot = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'video_fullscreen = "true"' >> ${INSTALL}/etc/retroarch.cfg

  # Audio
  echo 'audio_driver = "alsathread"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'audio_filter_dir = "/usr/share/audio_filters"' >> ${INSTALL}/etc/retroarch.cfg

  # Saving
  echo 'savestate_thumbnail_enable = "false"' >> ${INSTALL}/etc/retroarch.cfg

  # Input
  echo 'input_driver = "udev"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'input_max_users = "8"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'input_autodetect_enable = "true"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'joypad_autoconfig_dir = "/tmp/joypads"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'input_remapping_directory = "/storage/remappings"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'input_menu_toggle_gamepad_combo = "2"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'all_users_control_menu = "true"' >> ${INSTALL}/etc/retroarch.cfg

  # Menu
  echo 'menu_core_enable = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'thumbnails_directory = "/storage/thumbnails"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'menu_show_advanced_settings = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'menu_wallpaper_opacity = "1.0"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'content_show_images = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'content_show_music = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'content_show_video = "false"' >> ${INSTALL}/etc/retroarch.cfg

  # Playlists
  echo 'playlist_entry_rename = "false"' >> ${INSTALL}/etc/retroarch.cfg
  echo 'playlist_entry_remove = "false"' >> ${INSTALL}/etc/retroarch.cfg

  # iMX6
  if [ "${PROJECT}" = "NXP" -a "${DEVICE}" = "iMX6" ]; then
    echo 'audio_device = "default:CARD=DWHDMI"' >> ${INSTALL}/etc/retroarch.cfg
    echo 'audio_enable_menu = "true"' >> ${INSTALL}/etc/retroarch.cfg
    echo 'audio_enable_menu_ok = "true"' >> ${INSTALL}/etc/retroarch.cfg
    echo 'audio_enable_menu_cancel = "true"' >> ${INSTALL}/etc/retroarch.cfg
    echo 'audio_enable_menu_notice = "true"' >> ${INSTALL}/etc/retroarch.cfg
  fi

  # sort the options in config file
  sort ${INSTALL}/etc/retroarch.cfg > ${INSTALL}/etc/retroarch-sorted.cfg
  mv ${INSTALL}/etc/retroarch-sorted.cfg ${INSTALL}/etc/retroarch.cfg

  # create default environment file
  echo "HOME=/storage" >> ${INSTALL}/usr/lib/retroarch/retroarch-env.conf
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    echo "DISPLAY=:0.0" >> ${INSTALL}/usr/lib/retroarch/retroarch-env.conf
  elif [ "${DISPLAYSERVER}" = "wl" ]; then
    echo "WAYLAND_DISPLAY='wayland-1'" >> ${INSTALL}/usr/lib/retroarch/retroarch-env.conf
    echo "SWAYSOCK='/var/run/0-runtime-dir/sway-ipc.0.sock'" >> ${INSTALL}/usr/lib/retroarch/retroarch-env.conf
    echo "XDG_RUNTIME_DIR='/var/run/0-runtime-dir'" >> ${INSTALL}/usr/lib/retroarch/retroarch-env.conf
  fi

  cp -rf ${PKG_DIR}/scripts/frontend-retroarch.py ${INSTALL}/usr/bin/
  cp -rf ${PKG_DIR}/scripts/retroarch.start ${INSTALL}/usr/bin/retroarch.start
}

#post_install() {
#  enable_service retroarch.target
#  enable_service tmp-cores.mount
#  enable_service tmp-joypads.mount
#  enable_service tmp-database.mount
#  enable_service tmp-assets.mount
#  enable_service tmp-shaders.mount
#  enable_service tmp-overlays.mount
#  enable_service tmp-system.mount
#  enable_service retroarch-autostart.service
#  enable_service retroarch.service
#}
