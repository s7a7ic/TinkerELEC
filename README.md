# TinkerELEC

This is a fork of the popular [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) distribution, modified by me to run better on the **ASUS Tinker Board S**.

It's based on the master branch commit 6848c7a (6848c7aea52b385f884746152f33499c7319b911) from May 15, 2025.

Some packages were downgraded and patches were added to be able to run Kodi 21.2 (see commit history).

More information, some useful scripts and configurations to use after the installation can be found in the [Project Repository](https://github.com/s7a7ic/TinkerELEC-Project).

## Reason

I have the **ASUS Tinker Board S** which has an integrated Wireless LAN and Bluetooth Chip (RTL8723BS), but the driver support isn't so good as expected and the RK3288 SoC has some regressions with current Linux Kernels. So I'm trying to get a better working device with some minor changes (patches, different drivers).

Also I'm using the NesPi Case+ and wanted to have the "safe shutdown" functionality of the front panel buttons. I have planed to add an infrared receiver and temperature aware fan control integrated inside the case.

## Features

* Kodi 21.2
  * pcre depency patched out (pcre2 is used)
  * ffmpeg updated to 6.1.2 with v4l2-request patches created from [Kwiboo/FFmpeg](https://github.com/Kwiboo/FFmpeg/tree/v4l2-request-n6.1.1)
* Linux Kernel 6.12.23
* Updated packages from LibreELEC master branch
* Enabled Bluetooth
* Alternative Wireless Driver for RTL8723BS
* Enabled Watchdog
* Support for NesPi Case+ Buttons
  * Power: wake and "soft shutdown" when delatching
  * Reset: suspend, wake and reboot on longpress
  * PowerLED control via `/sys/class/leds/led-case` interface

## Image Types

*-tinker.img.gz: this is the default image

*-tinker-nespi.img.gz: this image has builtin support for the NesPi Case+ buttons

## Known Problems

**Bluetooth**
* can currently only connect to one device, every secondary device gets a timeout on connect

**Wireless LAN**
* WPA3 isn't working / supported by the driver

**Audio**
* no sound over 3.5mm jack (may be fixed with different configuration?)

## Resolved Problems

**Bluetooth**
* enabled by [dts-rk3288-tinker-bt-rtl8723bs.patch](projects/Rockchip/patches/linux/tinker-s/dts-rk3288-tinker-bt-rtl8723bs.patch)

**Wireless LAN**
* has good connection with the [alternative driver](packages/linux-drivers/RTL8723BS) (no invalid key error)

**Full Shutdown (kernel)**
* the device does not fully shutdown since Kernel 6.5 (power led stays on, device gets warm and draws power)
* [full-shutdown-rk808.patch](projects/Rockchip/patches/linux/tinker-s/full-shutdown-rk808.patch) enables previous full shutdown behaviour

**USB Devices (kernel)**
* devices connected over USB aren't detected while system is running and require a reboot
* this is fixed by [general-dwc2-fix-rk3288-reset-on-wake-quirk.patch](projects/Rockchip/patches/linux/tinker-s/general-dwc2-fix-rk3288-reset-on-wake-quirk.patch)

## Building the Image

Clone the repository:
```
git clone https://github.com/s7a7ic/TinkerELEC
```

Change into directory and run `make image`:
```
cd TinkerELEC
DEVICE=RK3288 ARCH=arm UBOOT_SYSTEM=tinker make image
```

## License

TinkerELEC original code is released under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html).
