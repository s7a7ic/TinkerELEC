import os.path
import subprocess
import xbmc
import xbmcaddon
import xbmcgui

ADDON = xbmcaddon.Addon()
ADDON_ID = ADDON.getAddonInfo("id")
ADDON_PATH = ADDON.getAddonInfo('path').rstrip("/")

CONF = "/storage/.config/modprobe.d/rtl8723bs-driver.conf"
CONF_OVERLAY = "/storage/.cache/kernel-overlays/rtl8723bs-overlay.conf"

MODULES = [ "8723bs", "rtw_8723bs", "r8723bs" ]

def get_loaded_module():
    link = "/sys/class/net/wlan0/device/driver/module"
    try:
        return os.path.basename(os.readlink(link))
    except (OSError, FileNotFoundError):
        return "none"

def write_blacklist(selected):
    lines = [
        f"# managed by {ADDON_ID} addon",
        f"# selected: {selected}",
        ""
    ]

    for name in MODULES:
        if name == selected:
            continue
        lines.append(f"blacklist {name}")

    os.makedirs(os.path.dirname(CONF), exist_ok=True)
    with open(CONF, "w") as f:
        f.write("\n".join(lines) + "\n")

def setup():
    """Ensure kernel-overlay conf exists and points to this addon."""
    expected = os.path.join(ADDON_PATH, "kernel-overlay") + "\n"

    if os.path.isfile(CONF_OVERLAY):
        try:
            with open(CONF_OVERLAY, "r") as f:
                if f.read() == expected:
                    return
        except OSError:
            pass

    os.makedirs(os.path.dirname(CONF_OVERLAY), exist_ok=True)
    with open(CONF_OVERLAY, "w") as f:
        f.write(expected)

def apply():
    selected = ADDON.getSetting("selected_module")
    write_blacklist(selected)
    xbmcgui.Dialog().ok(
        ADDON.getAddonInfo("name"),
        f"Selected: {selected}\nReboot required for the change to take effect."
    )

def main():
    setup()
    current = get_loaded_module()
    ADDON.setSetting("current_module", current)
    old = ADDON.getSetting("selected_module")
    ADDON.openSettings()
    # only apply when the user actually changed something
    new = ADDON.getSetting("selected_module")
    if new != old:
        apply()

if __name__ == "__main__":
    main()
