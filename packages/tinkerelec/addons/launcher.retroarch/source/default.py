import os.path
import subprocess
import sys
from xbmcaddon import Addon
from xbmcgui import Dialog

addon = Addon()
addon_dir = addon.getAddonInfo('path')
bin_folder = os.path.join(addon_dir, 'bin')
icon = addon.getAddonInfo('icon')
retroarch_exe = os.path.join(bin_folder, 'retroarch.start')
util_exe = os.path.join(bin_folder, 'retroarch_util.sh')

def runRetroarch():
	subprocess.run(['systemd-run', '-u', 'retroarch', retroarch_exe])

def getLocalizedString(id):
	if (id < 32000):
		return xbmc.getLocalizedString(id)
	else:
		return addon.getLocalizedString(id)

def testAssets():
	resp = subprocess.run([util_exe, "check_assets"])
	if resp.returncode == 0:
		Dialog().ok('RetroArch', getLocalizedString(32015))

if len(sys.argv) > 1:
	if sys.argv[1] == 'reset':
#		util.resetToDefaults()
		quit()

if (addon.getSetting("ra_hints") == 'true'):
	testAssets()

xbmc.executebuiltin('Notification(%s, %s, %d, %s)'%('RetroArch', getLocalizedString(20186), 60000, icon))
runRetroarch()
