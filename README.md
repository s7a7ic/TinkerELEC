# TinkerELEC

This is a fork of the popular [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) distribution, modified by me to run better on the **ASUS Tinker Board S**.

It's based on the libreelec-12.0 branch commit 6a7c6a427773cd9f7f5a93b6f525779c220ad350 from Jun 15, 2025.

More information, some useful scripts and configurations to use after the installation can be found in the [Project Repository](https://github.com/s7a7ic/TinkerELEC-Project).

## Reason

I have the **ASUS Tinker Board S** which has an integrated Wireless LAN and Bluetooth Chip (RTL8723BS), but the driver support isn't so good as expected and the RK3288 SoC has some regressions with current Linux Kernels. So I'm trying to get a better working device with some minor changes (patches, different drivers).

Also I'm using the NesPi Case+ and wanted to have the "safe shutdown" functionality of the front panel buttons. I have planed to add an infrared receiver and temperature aware fan control integrated inside the case.

## Features

- Kodi 21.2 (Omega) and Kernel 6.6.71
- Enabled Bluetooth by [dts-rk3288-tinker-bt-rtl8723bs.patch](projects/Rockchip/patches/linux/tinker-s/dts-rk3288-tinker-bt-rtl8723bs.patch)
- Alternative Wireless Driver for [RTL8723BS](packages/tinkerelec/linux-drivers/RTL8723BS)
- Enabled Watchdog
- Additional packages: btop, rsync

**Support for NesPi Case+ Buttons**
- Power Button: wake and "soft shutdown" when delatching
- Reset Button: suspend, wake and reboot (on longpress)
- Power LED control via /sys/class/leds/led-case interface

## Updated Packages (from LibreELEC.tv master branch)

- libcec 7.0.0

## Known Problems

**Bluetooth**
* can currently only connect to one device, every secondary device gets a timeout on connect

**Wireless LAN**
* WPA3 isn't working / supported by the driver

## Resolved Problems

**Full Shutdown (kernel)**
* the device does not fully shutdown since Kernel 6.5 (power led stays on, device gets warm and draws power)
* [full-shutdown-rk808.patch](projects/Rockchip/patches/linux/tinker-s/full-shutdown-rk808.patch) enables previous full shutdown behaviour

## License

TinkerELEC original code is released under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html).
