# RTL8723BS WiFi Driver Selector Addon

This addon includes two RTL8723BS WiFi drivers (kernel modules).

Currently it only includes modules built for the **kernel version 6.16.12** used by LibreELEC 12.2
and only for the ARMv7 architecture.

The addon works by creating a kernel-overlay config file `/storage/.cache/kernel-overlays/rtl8723bs-overlay.conf`
with the path to the addons provided kernel-overlay folder.
And a modprobe.d config file `/storage/.config/modprobe.d/rtl8723bs-driver.conf` in which the unused modules are blacklisted.

When selecting a kernel module in the addon, the modprobe.d config is updated and a reboot is required to apply the changes.

Icon attribution: [Wireless connectivity icons created by Magnific - Flaticon](https://www.flaticon.com/free-icons/wireless-connectivity)

## Selectable kernel modules

- 8723bs (included) = vendor driver patched for newer kernels (recommended)
- rtw_8723bs (included) = rtw88 driver prototype
- r8723bs = staging driver that already comes with the kernel

## Addon deinstallation

To completely remove the addon, it's required to delete the two mentioned config files manually.
