import os.path
import subprocess
import sys
import xbmc
from xbmcaddon import Addon
from xbmcgui import Dialog

addon = Addon()
addon_dir = addon.getAddonInfo('path')
bin_folder = os.path.join(addon_dir, 'bin')
icon = addon.getAddonInfo('icon')
util_script = os.path.join(bin_folder, 'nespi-dtb-install.sh')

title = 'NesPi+ DTB Installer'

def getLocalizedString(id):
	if (id < 32000):
		return xbmc.getLocalizedString(id)
	else:
		return addon.getLocalizedString(id)

def installDtb():
	install = subprocess.run([util_script, 'install', addon_dir])
	if install.returncode == 0:
		xbmc.executebuiltin('Notification(%s, %s, %d, %s)'%(title, 'Success', 5000, icon))
# TODO: ask wanna reboot?
#on fail: xbmc.executebuiltin('Notification(%s, %s, %d, %s)'%('NesPi+ DTB', 'dtb was not installed', 5000, icon))

def checkState():
	check = subprocess.run([util_script, 'check', addon_dir])
	if check.returncode == 0:
		Dialog().ok(title, 'The DTB file is already installed')
	else:
		ret = Dialog().yesno(title, 'Install or update the DTB file?')
		if ret == True:
			installDtb()

if len(sys.argv) > 1:
	if sys.argv[1] == 'reset':
		quit()

checkState()
