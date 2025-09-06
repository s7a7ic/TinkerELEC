# TinkerELEC

This is a fork of the popular [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) distribution, modified by me to run better on the **ASUS Tinker Board S**.

It's based on the libreelec-12.0 branch commit 6a7c6a427773cd9f7f5a93b6f525779c220ad350 from Jun 15, 2025.

I've previously tried to use LibreELEC master branch as a base, but the system had random crashes with Kodi 21.2. To find the issue I've started again from the libreelec-12.0 branch and sequentially update the packages to test for stability.

> [!NOTE]
> More information, some useful scripts and configurations to use after the installation can be found in the [Project Repository](https://github.com/s7a7ic/TinkerELEC-Project).

## Reason

I have the **ASUS Tinker Board S** which has an integrated Wireless LAN and Bluetooth Chip (RTL8723BS), but the driver support isn't so good as expected and the RK3288 SoC has some regressions with current Linux Kernels. So I'm trying to get a better working device with some minor changes (patches, different drivers).

Also I'm using the NesPi Case+ and wanted to have the "safe shutdown" functionality of the front panel buttons and I've added an IR-Receiver to be able to use my TV-Remote to control Kodi.
I have planed to add an temperature aware fan control integrated inside the case.

## Features

- Kodi 21.2 (Omega) and Kernel 6.12.23
- Pipewire as default audio backend (for "Low Volume Fix" see [Known Problems](#known-problems))
- Enabled Bluetooth by [dts-rk3288-tinker-bt-rtl8723bs.patch](projects/Rockchip/patches/linux/tinker-s/dts-rk3288-tinker-bt-rtl8723bs.patch)
- Alternative Wireless Driver for [RTL8723BS](packages/tinkerelec/linux-drivers/RTL8723BS)
- Enabled Watchdog
- Additional packages: btop, rsync
- Added alsa config for 3.5mm audio jack (need to test if it's still required for pipewire)

**Support for NesPi Case+ Buttons**
- Power Button: wake and "soft shutdown" when delatching
- Reset Button: suspend, wake and reboot (on longpress)
- Power LED control via /sys/class/leds/led-case interface
- [NesPi Case Patchfile for the RK3288-Tinker.dtsi](projects/Rockchip/patches/linux/nespi-case/dts-rk3288-tinker-nespi-case.patch)

**Infrared Receiver**
- [IR Receiver Patchfile for the RK3288-Tinker.dtsi](projects/Rockchip/patches/linux/nespi-case/dts-rk3288-tinker-ir-receiver.patch)

## Updated Packages (from LibreELEC.tv master and libreelec-12.2 branch)

- libcec 7.1.1
- libdrm 2.4.125
- mesa 25.1.9
- pipewire 1.4.7 / wireplumber 0.5.10
- python 3.11.13 (version >= 3.12 has compatibility issues with addons)

## Known Problems

**Low Volume with Pipewire**
* set volume to 100% with `wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%`
* set automatically on boot with [autostart.sh](https://github.com/s7a7ic/TinkerELEC-Project/blob/main/scripts/autostart.sh)

**Bluetooth**
* can currently only connect to one device, every secondary device gets a timeout on connect
* kodi sometimes crashes when gamepad disconnects (maybe related to pipewire, but was [patched](https://github.com/xbmc/xbmc/pull/26454)?)

**Wireless LAN**
* WPA3 isn't working / supported by the driver -> waiting for Kernel 6.17 wich should include changes of the RTL8723BS staging driver

## Resolved Problems

**Full Shutdown (kernel)**
* doesn't fully shutdown since Kernel 6.5 (power led stays on, device gets warm and draws power)
* [tinker-s-rk808-full-shutdown.patch](projects/Rockchip/patches/linux/tinker-s/tinker-s-rk808-full-shutdown.patch) enables previous full shutdown behaviour

**USB Device detection when system is running**
* doesn't detect USB devices plugged in when booted and running
* fixed by [general-dwc2-fix-rk3288-reset-on-wake-quirk.patch](projects/Rockchip/patches/linux/tinker-s/general-dwc2-fix-rk3288-reset-on-wake-quirk.patch)

## Credits

* https://github.com/libretro/Lakka-LibreELEC
* https://github.com/SupervisedThinking/LibreELEC-RR

## License

TinkerELEC original code is released under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html).
