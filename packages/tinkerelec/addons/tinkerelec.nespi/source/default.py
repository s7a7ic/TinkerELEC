import os.path
import subprocess
import sys
import xbmc
from xbmcaddon import Addon
from xbmcgui import Dialog

addon_dir = Addon().getAddonInfo('path')
bin_folder = os.path.join(addon_dir, 'bin')
icon = Addon().getAddonInfo('icon')
util_script = os.path.join(bin_folder, 'nespi-dtb-install.sh')

title = 'NesPi+ DTB Installer'

def sendNotification(message):
	xbmc.executebuiltin('Notification(%s, %s, %d, %s)'%(title, message, 5000, icon))

def installDtb():
	install = subprocess.run([util_script, 'install'])
	if install.returncode == 0:
		ret = Dialog().yesno(title, 'DTB file successfully installed, do you want to reboot?')
		if ret == True:
			subprocess.call('reboot')
	else:
		sendNotification('ERROR: failed to install')

def uninstallDtb():
	install = subprocess.run([util_script, 'uninstall'])
	if install.returncode == 0:
		sendNotification('Successfully Uninstalled')
	else:
		sendNotification('ERROR: failed to uninstall')

check = subprocess.run([util_script, 'check'])
if check.returncode == 0:
	ret = Dialog().yesno(title, 'DTB file is already installed, do you want to uninstall?')
	if ret == True:
		uninstallDtb()
elif check.returncode == 2:
	ret = Dialog().yesnocustom(title, 'DTB file is installed but had a checksum missmatch', 'Uninstall', 'Cancel', 'Update', 30000)
	if ret == 1:
		installDtb()
	elif ret == 2:
		uninstallDtb()
else:
	ret = Dialog().yesno(title, 'Install the DTB file?')
	if ret == True:
		installDtb()
