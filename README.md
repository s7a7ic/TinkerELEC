# TinkerELEC

This is a fork[^fork] of the popular [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) distribution, optimized for the **ASUS Tinker Board S** (Rockchip RK3288).

> [!NOTE]
> More information, some useful scripts and configurations to use after the installation can be found in the [Project Repository](https://github.com/s7a7ic/TinkerELEC-Project).

> [!CAUTION]
> This fork was not tested on any other device. I build images only for the Tinker Board S from the source code!

## Reason

I have the **ASUS Tinker Board S**, which has an integrated Wireless LAN and Bluetooth chip (RTL8723BS), but the driver support isn't as good as expected. The RK3288 SoC has some regressions with current Linux kernels. So I'm trying to get a better working device with some minor changes.

I'm using the "[NesPi Case+](https://github.com/RetroFlag/retroflag-picase)" and created patches for the device tree to be able to use the intended functionality of the front panel buttons. Also, an IR receiver was added to be able to use a TV remote to control Kodi. I plan to add a temperature-aware fan control integrated inside the case.

## Next Goals

* Further testing of kernel-6.18.x branch
  * fix usb dwc2 detection on running system and still be able to suspend
  * fix random freeze and reboot (often after suspend/resume)
* Emulation / Gaming
  * get mupen64plus-nx working
  * add Retroarch and Moonlight for gaming purposes

## Features

* Kodi 21.3 (Omega) and Kernel 6.12.23
  * [Modified Estuary Skin](packages/mediacenter/kodi-theme-Estuary)
    * smaller sidemenu and more vertical space
    * tv menu as first option
    * shutdown option removed from power menu in favor of using the power button
    * ~~close power dialog on suspend~~ - removed because of fix in [Kodi 3e65418](https://github.com/xbmc/xbmc/commit/3e65418c699ee006eb22436dd5794b4d626eeeea)
* Pipewire as default audio backend (for "Low Volume Fix" see [Known Problems](#known-problems))
* Enabled Bluetooth by [dts-rk3288-tinker-bt-rtl8723bs.patch](projects/Rockchip/patches/linux/tinker-s/dts-rk3288-tinker-bt-rtl8723bs.patch)
* Alternative Wireless Driver for [RTL8723BS](packages/tinkerelec/linux-drivers/RTL8723BS)
* Added alsa [config file](projects/Rockchip/filesystem/usr/share/alsa/cards/USB-Audio.conf) for working audio over the 3.5mm audio jack
* Enabled BFQ I/O scheduler
* Enabled 500 Mhz GPU frequency via [dts-rk3288-gpu-500mhz-opp.patch](projects/Rockchip/patches/linux/tinker-s/dts-rk3288-gpu-500mhz-opp.patch)
* Additional packages: btop, rsync
* Updated packages from the LibreELEC master branch (except essential package versions for Kodi 21)
  * ffmpeg 6.0.1, Python 3.11.13, taglib 1.13.1
  * packages/addons and packages/mediacenter/kodi-binary-addons are from the libreelec-12.2 branch

**Support for NesPi Case+ Buttons**
* [NesPi Case Patchfile for the RK3288-Tinker.dtsi](projects/Rockchip/patches/linux/nespi-case/dts-rk3288-tinker-nespi-case.patch)
* Power Button: wake from suspend and soft shutdown when delatching
* Reset Button: suspend, wake and reboot on longpress
* Power LED control via /sys/class/leds/led-case interface

**Infrared Receiver**
* [IR Receiver Patchfile for the RK3288-Tinker.dtsi](projects/Rockchip/patches/linux/nespi-case/dts-rk3288-tinker-ir-receiver.patch)

## Known Problems

**Low Volume with Pipewire**
* Set volume to 100% with `wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%`
* Set automatically on boot with [autostart.sh](https://github.com/s7a7ic/TinkerELEC-Project/blob/main/scripts/autostart.sh)

**Bluetooth (internal)**
* On kernel version below 6.17 it connects only to one device; every secondary device gets a timeout on connect

**Wireless LAN**
* WPA3 isn't supported by the alternative driver

**Kodi**
* Playback after suspend won't always continue, depending on the add-on or media last played
* So it's disabled in TinkerELEC via this [patch](packages/mediacenter/kodi/patches/kodi-200.01-disable-resume-playerstate-after-suspend.patch)

**System**
* Splash screen won't show on shutdown or reboot, after the system was resumed from suspend

## Resolved Problems

**Full Shutdown (kernel)**
* System doesn't fully shutdown since Kernel 6.5 (power led stays on, device gets warm and draws power)
* System automatically boots on Kernel 6.17+ after some time (about 30 seconds)
* [tinker-s-rk808-full-shutdown.patch](projects/Rockchip/patches/linux/tinker-s/tinker-s-rk808-full-shutdown.patch) enables full shutdown behaviour

**Wireless LAN**
* Stable WIFI connection with the [alternative driver](packages/tinkerelec/linux-drivers/RTL8723BS) on newer kernels (6.12 - 6.18)
* Loading of the kernel staging driver is disabled via [config file](packages/tinkerelec/linux-drivers/RTL8723BS/config/modprobe.d/disable-rtl8723bs-staging-driver.conf)

**USB Device detection when system is running (kernel)**
* System doesn't detect USB devices plugged in when fully booted and running
* (on kernel 6.12.23) fixed by [general-dwc2-fix-rk3288-reset-on-wake-quirk.patch](projects/Rockchip/patches/linux/tinker-s/general-dwc2-fix-rk3288-reset-on-wake-quirk.patch)

**Audio over 3.5mm Jack**
* Added required [config file](projects/Rockchip/filesystem/usr/share/alsa/cards/USB-Audio.conf)
* The output source in Kodi and pipewire is called "USB Audio ..."

## Install to EMMC

To install a TinkerELEC image from SDCARD onto the internal emmc storage, you can use the [`emmctool` script](packages/tools/emmctool/scripts/emmctool).

> [!CAUTION]
> Use `emmctool` with care. Can wipe data from emmc/sdcard storage.

## Credits

Like any Linux distribution, this project is not the work of one person. It is the work of many persons all over the world who have developed the open source bits without which this project could not exist. Special thanks to [Armbian](https://github.com/armbian/build), [CoreELEC](https://github.com/CoreELEC/CoreELEC), [Lakka](https://github.com/libretro/Lakka-LibreELEC), [LibreELEC](https://github.com/LibreELEC/LibreELEC.tv), [ROCKNIX](https://github.com/ROCKNIX/distribution), [SupervisedThinking](https://github.com/SupervisedThinking/LibreELEC-RR) and to developers and contributors across the open source community.

## License

TinkerELEC original code is released under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html).

[^fork]: It's based on the libreelec-12.0 branch commit 6a7c6a427773cd9f7f5a93b6f525779c220ad350 from Jun 15, 2025.
