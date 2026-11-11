import os.path
import subprocess
import xbmc
import xbmcaddon

ADDON = xbmcaddon.Addon()
ADDON_DIR = ADDON.getAddonInfo('path')
ADDON_BIN_DIR = os.path.join(ADDON_DIR, 'bin')

util_script = os.path.join(ADDON_BIN_DIR, 'tinkerelec-config')

class Monitor(xbmc.Monitor):
    def onSettingsChanged(self):
        subprocess.call([util_script, 'profile'])

if __name__ == '__main__':
    Monitor().waitForAbort()
