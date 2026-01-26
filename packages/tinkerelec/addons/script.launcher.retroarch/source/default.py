# SPDX-License-Identifier: GPL-2.0

import subprocess
import xbmc
import xbmcaddon

ADDON_ID = 'script.launcher.retroarch'

addon = xbmcaddon.Addon(id=ADDON_ID)
addon_dir = addon.getAddonInfo('path')
bin_folder = os.path.join(addon_dir, 'bin')
icon = addon.getAddonInfo('icon')
retroarch_exe = os.path.join(bin_folder, 'retroarch.start')

def systemctl(command):
    subprocess.call(['systemctl', command, 'retroarch'])
    #subprocess.run(retroarch_exe)

def send_notification():
    line1 = "Launching RetroArch"
    xbmc.executebuiltin('Notification(%s, %s, %d)'%('RetroArch', line1, 5000, icon))

if __name__ == "__main__":
    send_notification()
    systemctl('start')
