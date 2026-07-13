import os.path
import subprocess
import xbmc
from xbmcaddon import Addon
from xbmcgui import Dialog

addon_dir = Addon().getAddonInfo('path')
bin_folder = os.path.join(addon_dir, 'bin')
util_script = os.path.join(bin_folder, 'tinkerelec-config.sh')

class Monitor(xbmc.Monitor):

    def __init__(self, *args, **kwargs):
        xbmc.Monitor.__init__(self)

    def onSettingsChanged(self):
        subprocess.call([util_script, 'profile'])

if __name__ == '__main__':
    Dialog().ok('Information', 'This addon has no GUI.')
    Monitor().waitForAbort()
