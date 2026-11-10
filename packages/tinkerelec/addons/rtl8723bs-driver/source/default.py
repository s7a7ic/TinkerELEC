import os.path
import platform
import subprocess
import xbmcaddon
import xbmcgui

ADDON = xbmcaddon.Addon()
ADDON_ID = ADDON.getAddonInfo("id")
ADDON_PATH = ADDON.getAddonInfo('path').rstrip("/")
ADDON_NAME = ADDON.getAddonInfo("name")

CONF = "/storage/.config/modprobe.d/rtl8723bs-driver.conf"
CONF_OVERLAY = "/storage/.cache/kernel-overlays/rtl8723bs-overlay.conf"

MODULES = ["8723bs", "rtw_8723bs", "r8723bs"]
LABELS  = [
    "8723bs (vendor, recommended)",
    "rtw_8723bs (rtw88)",
    "r8723bs (kernel staging)",
]
DEFAULT_MODULE = "8723bs"

REQUIRED_KERNEL = "6.16.12"
REQUIRED_ARCH = "armv7l"

def check_platform():
    errors = []

    if not os.path.isdir("/storage/.kodi"):
        errors.append("missing /storage/.kodi")

    kernel = platform.release().split("-")[0]
    if kernel != REQUIRED_KERNEL:
        errors.append(f"kernel {kernel} (need {REQUIRED_KERNEL})")

    arch = platform.machine()
    if arch != REQUIRED_ARCH:
        errors.append(f"arch {arch} (need {REQUIRED_ARCH})")

    if errors:
        xbmcgui.Dialog().ok(ADDON_NAME, "Unsupported platform:\n" + "\n".join(errors))
        return False
    return True

def get_loaded_module():
    link = "/sys/class/net/wlan0/device/driver/module"
    try:
        return os.path.basename(os.readlink(link))
    except (OSError, FileNotFoundError):
        return "none"

def write_blacklist(selected):
    lines = [f"# managed by {ADDON_ID} addon", f"# selected: {selected}", ""]
    for name in MODULES:
        if name == selected:
            continue
        lines.append(f"blacklist {name}")
    os.makedirs(os.path.dirname(CONF), exist_ok=True)
    with open(CONF, "w") as f:
        f.write("\n".join(lines) + "\n")

def setup():
    expected = os.path.join(ADDON_PATH, "kernel-overlay") + "\n"
    if not os.path.isfile(CONF_OVERLAY) or open(CONF_OVERLAY).read() != expected:
        os.makedirs(os.path.dirname(CONF_OVERLAY), exist_ok=True)
        with open(CONF_OVERLAY, "w") as f:
            f.write(expected)

    if not os.path.isfile(CONF):
        current = get_loaded_module()
        selected = current if current in MODULES else DEFAULT_MODULE
        write_blacklist(selected)

def choose_module():
    current = get_loaded_module()
    # pre-select current if known
    pre = MODULES.index(current) if current in MODULES else -1
    idx = xbmcgui.Dialog().select(
        f"{ADDON_NAME}  (current: [COLOR yellow]{current}[/COLOR])",
        LABELS,
        preselect=pre if pre >= 0 else 0,
    )
    if idx < 0 or idx == pre: # cancelled or current
        return None
    return MODULES[idx]

def main():
    if not check_platform():
        return
    setup()
    selected = choose_module()
    if selected is None:
        return
    if xbmcgui.Dialog().yesno(ADDON_NAME,
        f"Selected: [COLOR yellow]{selected}[/COLOR]\nA reboot is required for the change to take effect.\nReboot now?"
    ):
        write_blacklist(selected)
        subprocess.call(["reboot"])

if __name__ == "__main__":
    main()
