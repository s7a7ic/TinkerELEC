# TinkerELEC

This is a fork[^fork] of the popular [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) distribution, optimized for the **ASUS Tinker Board S** (Rockchip RK3288).

> [!CAUTION]
> This fork was not tested on any other device than the **Tinker Board S**!

> [!NOTE]
> More information, some useful scripts and configurations to use after the installation can be found in the [Project Repository](https://github.com/s7a7ic/TinkerELEC-Project).
> Debian 12 (Bookworm) is used to build images from this source code.

## Reason

I have the **ASUS Tinker Board S**, which has an integrated Wireless LAN and Bluetooth chip (RTL8723BS), but the driver support isn't as good as expected. The RK3288 SoC has some regressions with current Linux kernels. So I'm trying to get a better working device with some minor changes. There are some extra packages, that I created for my personal use-case.

I'm using the "[NesPi Case+](https://github.com/RetroFlag/retroflag-picase)" and created patches for the devicetree to be able to use the intended functionality of the front panel buttons (installable DTB via addon). Also, an IR receiver was added to be able to use a TV remote to control Kodi. I plan to add a temperature-aware fan control integrated inside the case.

## Goals

* Keep source compatible with LibreELEC.tv master branch (update packages, but keep system stable while running Kodi Omega until the release of Kodi 22 Nexus)

* Next Release
  * Kernel 6.19 + patches and testing of rtl8723bs staging driver
  * Own Repository for specific Addons
  * Test ffmpeg 7.1.3 with patches
  * Test Kodi 22 Alpha on separate branch

* Emulation / Gaming
  * Test RetroArch and enhance launcher addon
  * Enhance mupen64plus-nx libretro performance
  * Enhance game launching capability in kodi (test something like Advanced Emulator Launcher)
  * Add Moonlight for game streaming if possible

* Kodi
  * Add "Sleep Timer" reminder notification (develop addon for this)

## Features and Changes

Updated packages from LibreELEC.tv master branch

**Kodi 21.3 (Omega)**
* Packages kept on specific version for Kodi 21 compatibility and stability
  * ffmpeg 6.1.4 (patched), python 3.11.13, taglib 1.13.1
  * `packages/addons` and `packages/mediacenter/kodi-binary-addons` are from the libreelec-12.2 branch
* Patches for Kodi
  * [sleep timer (shutdown/suspend)](packages/mediacenter/kodi/patches/kodi21-default-shutdown-timer.patch) defaults to 30 minutes; prevents instant sleep action, when accidentialy pressing OK twice
  * [reduced cpu load on idle](packages/mediacenter/kodi/patches/kodi21-gbm-reduce-cpu-idle-load.patch)
  * fix bluetooth sound lag with pipewire [(patch from xbmc nexus branch)](packages/mediacenter/kodi/patches/kodi21-pipewire-fix-bt-lag.patch)
  * [removed pcre dependency](packages/mediacenter/kodi/patches/kodi21-remove-use-of-prcecpp.patch) in favor of pcre2
  * crash fix when changing skins or language [(xbmc issue)](https://github.com/xbmc/xbmc/issues/27552)
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
* Alternative Wireless Driver for [RTL8723BS](packages/linux-drivers/RTL8723BS)
* Pipewire as default audio backend (for "Low Volume Fix" see [Known Problems](#known-problems))
* On Suspend / On Resume script support [via custom-sleep.sh](packages/mediacenter/kodi/sleep.d.serial/20-custom-sleep.sh)
* Additional packages included in image: btop, evtest, rsync

**Tinker Board S specific**
* GCC kept on version 13.2.0 for better stability
* Added alsa [config file](projects/Rockchip/devices/TinkerBoard/filesystem/usr/share/alsa/cards/USB-Audio.conf) for working audio over the 3.5mm audio jack
* Enabled Bluetooth by [dts-rk3288-tinker-bt-rtl8723bs.patch](projects/Rockchip/devices/TinkerBoard/patches/linux/default/dts-rk3288-tinker-bt-rtl8723bs.patch)
* Enabled 500 Mhz GPU frequency via [dts-rk3288-gpu-500mhz-opp.patch](projects/Rockchip/devices/TinkerBoard/patches/linux/default/dts-rk3288-gpu-500mhz-opp.patch)

**Extra Package with modifications for my use-case**
* [Package "tinkerelec-config"](packages/tinkerelec/tinkerelec-config/)
* Prevent Kodi of reacting to events from the NesPi Case buttons or physical power buttons (modified 70-libinput-ignore-power-button.rules)
* TV IR remote configuration
* Gamepad configuration for Kodi
* Disabled connman online check

**Support for NesPi Case+ Buttons**
* The DTS file can be installed via [kodi addon](packages/tinkerelec/addons/tinkerelec.nespi)
* [NesPi Case Patchfile for the RK3288-Tinker.dtsi](packages/tinkerelec/addons/tinkerelec.nespi/patches/dts-rk3288-tinker-nespi-case.patch)
* Power Button: wake from suspend and soft shutdown when delatching
* Reset Button: suspend, wake and reboot on longpress
* Power LED control via /sys/class/leds/led-case interface

**Infrared Receiver**
* [IR Receiver Patchfile for the RK3288-Tinker.dtsi](packages/tinkerelec/addons/tinkerelec.nespi/patches/dts-rk3288-tinker-ir-receiver.patch)

## Known Problems

**DNS resolution is not working after the setup-wizard**
- Reboot system or restart connman and network-base service

**Low Volume with Pipewire**
* Fixed for the default audio sink via [service file](packages/audio/pipewire/system.d/pipewire-volume.service)
* Volume can be set to 100% with this command: `wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%`
* If you want to set this in autostart.sh (maybe for another sink), Kodi has to be running

**Wireless LAN**
* WPA3 isn't supported by the rtl8723bs driver (yet?)

**Kodi**
* Playback after suspend won't always continue, depending on the add-on or media last played
  * So it's disabled in TinkerELEC via this [patch](packages/mediacenter/kodi/patches/kodi-200.01-disable-resume-playerstate-after-suspend.patch)
* Shadertoy visualization causes graphical glitches on menu icons and text
* AirPlay was disabled because of the error "zeroconf not enabled" with updated packages; I'm using [Snapcast](https://github.com/snapcast/snapcast) for this task
* Games with libretro aspect ratio... dont change to ???

**System**
* Splash screen won't show after the system was resumed from suspend (on shutdown or reboot)

## Resolved Problems

**Full Shutdown (kernel)**
* System doesn't fully shutdown since Kernel 6.5 (power led stays on, device gets warm and draws power)
* System automatically boots on Kernel 6.16+ after some time (about 30 seconds)
* [tinker-s-rk808-full-shutdown.patch](projects/Rockchip/devices/TinkerBoard/patches/linux/default/tinker-s-rk808-full-shutdown.patch) enables full shutdown behaviour

**Wireless LAN**
* Stable WIFI connection with the [alternative driver](packages/linux-drivers/RTL8723BS) on newer kernels (6.12 - 6.19)
* Loading of the kernel staging driver is disabled [config file](packages/linux-drivers/RTL8723BS/config/modprobe.d/disable-rtl8723bs-staging-driver.conf)
* ~~Disabling power saving with module parameters for the staging driver led to a stable wifi connection~~

**Bluetooth (internal)**
* On mainline kernel version below 6.16 it connects only to one device; every secondary device gets a timeout on connect

**USB Device detection when system is running**
* System doesn't detect USB devices plugged in when fully booted and running
* Fixed with [udev rule](projects/Rockchip/devices/TinkerBoard/filesystem/usr/lib/udev/rules.d/99-disable-usb-autosuspend.rules), which disables USB autosuspend
* (on kernel 6.12.23) fixed by [general-dwc2-fix-rk3288-reset-on-wake-quirk.patch](https://github.com/s7a7ic/TinkerELEC-Project/blob/main/patches/linux-6.12/general-dwc2-fix-rk3288-reset-on-wake-quirk.patch)

**Audio over 3.5mm Jack**
* Added required [config file](projects/Rockchip/devices/TinkerBoard/filesystem/usr/share/alsa/cards/USB-Audio.conf)
* The output source in Kodi and pipewire is called "USB Audio ..."

**Random SEGFAULT (system freeze + crash)**
* I've identified gcc 15 as the culprid for random (hard to reproduce) system crashes and decided to stay on gcc 13.2.0 to keep the system stable
* Added some [patches for gcc 13](packages/lang/gcc/patches/) to build and run an updated system (with glibc 2.42)

## Install to EMMC

To install a TinkerELEC image from SDCARD onto the internal emmc storage, you can use the [`emmctool` script](packages/tools/emmctool/scripts/emmctool).

> [!CAUTION]
> Use `emmctool` with care. Can wipe data from emmc/sdcard storage.

## Credits

Like any Linux distribution, this project is not the work of one person. It is the work of many persons all over the world who have developed the open source bits without which this project could not exist. Special thanks to [Armbian](https://github.com/armbian/build), [CoreELEC](https://github.com/CoreELEC/CoreELEC), [Lakka](https://github.com/libretro/Lakka-LibreELEC), [LibreELEC](https://github.com/LibreELEC/LibreELEC.tv), [ROCKNIX](https://github.com/ROCKNIX/distribution), [SupervisedThinking](https://github.com/SupervisedThinking/LibreELEC-RR) and to developers and contributors across the open source community.

## License

TinkerELEC original code is released under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html).

[^fork]: It's based on the libreelec-12.0 branch commit 6a7c6a427773cd9f7f5a93b6f525779c220ad350 from Jun 15, 2025.
