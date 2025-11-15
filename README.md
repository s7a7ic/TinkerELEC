# TinkerELEC

This is a fork[^fork] of the popular [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) distribution, optimized for the **ASUS Tinker Board S** (Rockchip RK3288).

The system reached a very stable state on rc5 (see [features](#features) for more info).

> [!NOTE]
> More information, some useful scripts and configurations to use after the installation can be found in the [Project Repository](https://github.com/s7a7ic/TinkerELEC-Project).

## Reason

I have the **ASUS Tinker Board S**, which has an integrated Wireless LAN and Bluetooth chip (RTL8723BS), but the driver support isn't as good as expected. The RK3288 SoC has some regressions with current Linux kernels. So I'm trying to get a better working device with some minor changes.

I'm using the "[NesPi Case+](https://github.com/RetroFlag/retroflag-picase)" and created patches for the device tree to be able to use the intended functionality of the front panel buttons. Also, an IR receiver was added to be able to use a TV remote to control Kodi. I plan to add a temperature-aware fan control integrated inside the case.

## Next Goals

* Update to Kernel 6.17+ and fix issues
* Get source closer to master branch, exept essential packages required for Kodi 21
* Modify `emmctool` or create a similar tool to simply clone the storage partition in both ways between emmc and sdcard
* Add Retroarch and Moonlight for gaming purposes

## Features

* Kodi 21.3 (Omega) and Kernel 6.12.23
  * [Modified Estuary Skin](packages/mediacenter/kodi-theme-Estuary)
    * smaller sidemenu and more vertical space
    * tv menu as first option
    * ~~close power dialog on suspend~~ - removed because of fix in [Kodi 3e65418](https://github.com/xbmc/xbmc/commit/3e65418c699ee006eb22436dd5794b4d626eeeea)
* Pipewire as default audio backend (for "Low Volume Fix" see [Known Problems](#known-problems))
* Enabled Bluetooth by [dts-rk3288-tinker-bt-rtl8723bs.patch](projects/Rockchip/patches/linux/tinker-s/dts-rk3288-tinker-bt-rtl8723bs.patch)
* Alternative Wireless Driver for [RTL8723BS](packages/tinkerelec/linux-drivers/RTL8723BS)
* Added alsa [config file](projects/Rockchip/filesystem/usr/share/alsa/cards/USB-Audio.conf) for working audio over the 3.5mm audio jack
* Enabled 500 Mhz GPU frequency via [dts-rk3288-gpu-500mhz-opp.patch](projects/Rockchip/patches/linux/tinker-s/dts-rk3288-gpu-500mhz-opp.patch)
* Additional packages: btop, emmctool, rsync
* Updated packages from the LibreELEC master branch

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
* Can currently only connect to one device; every secondary device gets a timeout on connect
* Works on kernel 6.17 or can be fixed with a Bluetooth USB dongle

**Wireless LAN**
* WPA3 isn't supported by the alternative driver

**Kodi**
* Playback after suspend won't always continue, depending on the add-on or media last played
* So it's disabled in TinkerELEC via this [patch](packages/mediacenter/kodi/patches/kodi-200.01-disable-resume-playerstate-after-suspend.patch)

## Resolved Problems

**Full Shutdown (kernel)**
* System doesn't fully shutdown since Kernel 6.5 (power led stays on, device gets warm and draws power)
* [tinker-s-rk808-full-shutdown.patch](projects/Rockchip/patches/linux/tinker-s/tinker-s-rk808-full-shutdown.patch) enables previous full shutdown behaviour

**USB Device detection when system is running (kernel)**
* System doesn't detect USB devices plugged in when fully booted and running
* fixed by [general-dwc2-fix-rk3288-reset-on-wake-quirk.patch](projects/Rockchip/patches/linux/tinker-s/general-dwc2-fix-rk3288-reset-on-wake-quirk.patch)

**Audio over 3.5mm Jack**
* Added required [config file](projects/Rockchip/filesystem/usr/share/alsa/cards/USB-Audio.conf)
* The output source in Kodi and pipewire is called "USB Audio ..."

## Install to EMMC

To install a TinkerELEC image from SDCARD onto the internal emmc storage, you can use the [`emmctool` script](packages/tools/emmctool/scripts/emmctool).

> [!CAUTION]
> Use `emmctool` with care. Can wipe data from emmc/sdcard storage.

## Credits

Like any Linux distribution, this project is not the work of one person. It is the work of many persons all over the world who have developed the open source bits without which this project could not exist. Special thanks to [CoreELEC](https://github.com/CoreELEC/CoreELEC), [Lakka](https://github.com/libretro/Lakka-LibreELEC), [LibreELEC](https://github.com/LibreELEC/LibreELEC.tv), [ROCKNIX](https://github.com/ROCKNIX/distribution), [SupervisedThinking](https://github.com/SupervisedThinking/LibreELEC-RR) and to developers and contributors across the open source community.

## License

TinkerELEC original code is released under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html).

[^fork]: It's based on the libreelec-12.0 branch commit 6a7c6a427773cd9f7f5a93b6f525779c220ad350 from Jun 15, 2025.
