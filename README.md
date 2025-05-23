# TinkerELEC

This is a fork of the popular [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) distribution, modified by me to run better on the ASUS Tinker Board S.

It's based on the master branch commit 6848c7a (6848c7aea52b385f884746152f33499c7319b911) from May 15, 2025.

Some packages were downgraded and patches were added to be able to run Kodi 21.2 (see commit history).

Information about this Project can be found in the [Project Repository](https://github.com/s7a7ic/TinkerELEC-Project).

## Reason

I have an ASUS Tinker Board S which has an integrated Wireless LAN and Bluetooth Chip (RTL8723BS) but the driver support isn't so good as expected on LibreELEC and the RK3288 SoC has some regressions with current Linux Kernels. So I'm trying to get a better working device with some minor changes (patches, different drivers).

## Known Problems

**Bluetooth**
* works when enabled by the dts-rk3288-tinker-bt-rtl8723bs.patch
* can currently only connect to one device, every secondary device gets a timeout on connect

**Wireless LAN**
* has good connection with the alternative driver (no invalid key error)
* WPA3 isn't working / supported by the driver

**Full Shutdown (kernel)**
* the device does not fully shutdown since Kernel 6.5 (power led stays on, device gets warm and draws power)
* full-shutdown-rk808.patch enables previous full shutdown behaviour

**USB Devices (kernel)**
* devices connected over USB aren't detected while system is running and require a reboot
* this is fixed by general-dwc2-fix-rk3288-reset-on-wake-quirk.patch

## License

TinkerELEC original code is released under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html).
