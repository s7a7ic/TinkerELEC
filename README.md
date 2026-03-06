# TinkerELEC

This is a fork[^fork] of the popular [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) distribution, optimized for the **ASUS Tinker Board S** (Rockchip RK3288).

> [!CAUTION]
> This fork was not tested on any other device than the **Tinker Board S**!
> Debian 12 (Bookworm) is used currently to build images from this source code.

## Reason

I have the **ASUS Tinker Board S**, which has an integrated Wireless LAN and Bluetooth chip (RTL8723BS), but the driver support isn't as good as expected. The Rockchip RK3288 SoC has some regressions with current Linux kernels. So I'm trying to get a better working device with some minor changes. There are some extra packages, that I created for my personal use-case.

I'm using the "[NesPi Case+](https://github.com/RetroFlag/retroflag-picase)" and created patches for the devicetree to be able to use the intended functionality of the front panel buttons (installable DTB via Kodi addon). Also, an IR receiver was added to be able to use a TV remote to control Kodi. I want to add a temperature-aware pwm fan control integrated inside the case.

> [!NOTE]
> More information about my use-case, some useful scripts and configurations to use after the installation can be found in the [Project Repository](https://github.com/s7a7ic/TinkerELEC-Project).

## Features and Changes

**Kodi 21.3 (Omega)**
* Patches for Kodi
  * [sleep timer (shutdown/suspend)](packages/mediacenter/kodi/patches/kodi-200.02-default-shutdown-timer.patch) defaults to 30 minutes; prevents instant sleep action, when accidentialy pressing OK twice
  * [reduced cpu load on idle](packages/mediacenter/kodi/patches/kodi-200.04-gbm-reduce-cpu-idle-load.patch)
  * fix bluetooth sound lag with pipewire [(patch from xbmc master branch)](packages/mediacenter/kodi/patches/kodi-200.05-pipewire-fix-bt-lag.patch)
  * [removed pcre dependency](packages/mediacenter/kodi/patches/kodi-200.06-remove-use-of-prcecpp.patch) in favor of pcre2
  * [crash fix when changing skins or language](packages/mediacenter/kodi/patches/kodi-200.03-rework-add-on-skin-reloading.patch) [(xbmc issue)](https://github.com/xbmc/xbmc/issues/27552)
  * don't restart [playback after resume from suspend](packages/mediacenter/kodi/patches/kodi-200.01-disable-resume-playerstate-after-suspend.patch)
* [Modified Estuary Skin](packages/tinkerelec/kodi-theme-tinkerelec) (not enabled by default, needs to be enabled and selected)
  * smaller sidemenu and more vertical space
  * tv menu as first option
  * shutdown option removed from power menu in favor of using the power button
  * ~~close power dialog on suspend~~ - removed because of fix in [Kodi 3e65418](https://github.com/xbmc/xbmc/commit/3e65418c699ee006eb22436dd5794b4d626eeeea)

**Kernel 6.16.12**
* Enabled BFQ I/O scheduler (not enabled by default)
* CONFIG_HZ set to 100 instead of 300 (smoother UI response, probably less cpu interrupt overhead)
* Disabled XFS / BTRFS support

**System / Image changes**
* Alternative wireless driver for [RTL8723BS](packages/linux-drivers/RTL8723BS)
* Additional packages included in image: btop, emmctool, evtest, rsync

**Tinker Board S specific**
* Added alsa [config file](projects/Rockchip/devices/TinkerBoard/filesystem/usr/share/alsa/cards/USB-Audio.conf) for working audio over the 3.5mm audio jack
* Enabled Bluetooth: [dts-rk3288-tinker-bt-rtl8723bs](projects/Rockchip/devices/TinkerBoard/patches/linux/default/dts-rk3288-tinker-bt-rtl8723bs.patch)
* Enabled 500 Mhz GPU frequency: [dts-rk3288-gpu-500mhz-opp](projects/Rockchip/devices/TinkerBoard/patches/linux/default/dts-rk3288-gpu-500mhz-opp.patch)
* Enable HVEC and RGA node: [dts-rk3288-tinker-hevc-rga](projects/Rockchip/devices/TinkerBoard/patches/linux/default/dts-rk3288-tinker-hevc-rga.patch)
* Full shutdown patch: [mfd-rk8xx-fix-shutdown-handler](projects/Rockchip/devices/TinkerBoard/patches/linux/default/rockchip-0060-mfd-rk8xx-fix-shutdown-handler.patch)

**Extra Package with modifications for my use-case**
* Package: ["tinkerelec-config"](packages/tinkerelec/tinkerelec-config/)
* On Suspend / On Resume [script support](packages/tinkerelec/tinkerelec-config/config/sleep.d/suspend_resume.power)
* Prevent Kodi of reacting to events from the NesPi Case buttons or physical power buttons (modified 70-libinput-ignore-power-button.rules)
* TV IR remote configuration
* Gamepad configuration for Kodi
* Disabled connman online check by default: `/storage/.config/connman_main.conf`

**Patched DTB for my use-case**
* [Kodi addon package](packages/tinkerelec/addons/tinkerelec.nespi) for installing the patched DTB
* [Support for NesPi Case+ Buttons](packages/tinkerelec/addons/tinkerelec.nespi/patches/dts-rk3288-tinker-nespi-case.patch)
  * Power Button: wake from suspend and soft shutdown when delatching
  * Reset Button: suspend, wake and reboot on longpress
  * Power LED control through `/sys/class/leds/led-case` interface
* [Infrared Receiver](packages/tinkerelec/addons/tinkerelec.nespi/patches/dts-rk3288-tinker-ir-receiver.patch)

## Known Problems

**DNS resolution is not working after the setup-wizard**
- Reboot system or restart connman and network-base service

**Wireless LAN**
* WPA3 isn't supported by the rtl8723bs driver (yet?)
* Staging driver won't show all SSIDs, has random disconnects and can't reliably reconnect

**Kodi**
* Playback after suspend won't always continue, depending on the add-on or media last played
  * So it's disabled in TinkerELEC with this [patch](packages/mediacenter/kodi/patches/kodi-200.01-disable-resume-playerstate-after-suspend.patch)
* Shadertoy visualization for music playback causes graphical glitches on menu icons and text
* Setting the "Stretch" mode to "original" for games under libretro causes an extremly zoomed in Kodi UI and a restart is required (has to be changed back blindly)

**System**
* Splash screen won't show (on shutdown or reboot) after the system was resumed from suspend

## Resolved Problems

**Full Shutdown (kernel)**
* System didn't fully shutdown since Kernel 6.5 (power led stays on, device gets warm and draws power)
* System automatically booted on Kernel 6.16+ after some time (about 30 seconds)
* Fixed by [tinker-s-rk808-full-shutdown.patch](projects/Rockchip/devices/TinkerBoard/patches/linux/default/tinker-s-rk808-full-shutdown.patch)

**Wireless LAN (internal)**
* Stable WIFI connection with the [alternative driver](packages/linux-drivers/RTL8723BS) on newer kernels (6.12 - 6.19)
* Loading of the kernel staging driver is [blacklisted](projects/Rockchip/devices/TinkerBoard/filesystem/usr/config/modprobe.d/rtl8723bs-driver.conf) for TinkerBoard
* ~~Disabling power saving with module parameters for the staging driver led to a stable wifi connection~~

**Bluetooth (internal)**
* On mainline kernel version below 6.16 it connects only to one device; every secondary device gets a timeout on connect

**USB Device detection when system is running**
* System didn't detect USB devices plugged in when fully booted and running
* Fixed with [udev rule](projects/Rockchip/devices/TinkerBoard/filesystem/usr/lib/udev/rules.d/99-disable-usb-autosuspend.rules), which disables USB autosuspend
* (on kernel 6.12.23) fixed by [general-dwc2-fix-rk3288-reset-on-wake-quirk.patch](https://github.com/s7a7ic/TinkerELEC-Project/blob/main/patches/linux-6.12/general-dwc2-fix-rk3288-reset-on-wake-quirk.patch)

**Audio over 3.5mm Jack**
* Added required [config file](projects/Rockchip/devices/TinkerBoard/filesystem/usr/share/alsa/cards/USB-Audio.conf)
* The output source in Kodi and pipewire is called "USB Audio ..."

## Install to EMMC

To install a TinkerELEC image from SDCARD onto the internal emmc storage, you can use the [`emmctool` script](packages/tools/emmctool/scripts/emmctool).

> [!CAUTION]
> Use `emmctool` with care. Can wipe data from emmc/sdcard storage.

## Credits

Like any Linux distribution, this project is not the work of one person. It is the work of many persons all over the world who have developed the open source bits without which this project could not exist. Special thanks to [Armbian](https://github.com/armbian/build), [CoreELEC](https://github.com/CoreELEC/CoreELEC), [Lakka](https://github.com/libretro/Lakka-LibreELEC), [LibreELEC](https://github.com/LibreELEC/LibreELEC.tv), [ROCKNIX](https://github.com/ROCKNIX/distribution), [SupervisedThinking](https://github.com/SupervisedThinking/LibreELEC-RR) and to developers and contributors across the open source community.

## License

TinkerELEC original code is released under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html).

[^fork]: this branch is based on the libreelec-12.2 branch commit 71b3d24c2177c0c6833734e021e4b98ac581f6fc from Feb 27, 2026.
