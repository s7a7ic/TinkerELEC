import os.path
import subprocess
import xbmc
import xbmcaddon
from xbmcgui import Dialog

ADDON = xbmcaddon.Addon()
ADDON_DIR = ADDON.getAddonInfo('path')
ADDON_BIN_DIR = os.path.join(ADDON_DIR, 'bin')
util_script = os.path.join(ADDON_BIN_DIR, 'nespi-dtb-install')
ICON = ADDON.getAddonInfo('icon')

title = 'NesPi+ DTB Installer'

def sendNotification(message):
	xbmc.executebuiltin('Notification(%s, %s, %d, %s)'%(title, message, 5000, ICON))

def installDtb():
	install = subprocess.run([util_script, 'install'])
	if install.returncode == 0:
		if Dialog().yesno(title, 'DTB file successfully installed, do you want to reboot?'):
			subprocess.call('reboot')
	else:
		sendNotification('ERROR: failed to install')

def uninstallDtb():
	install = subprocess.run([util_script, 'uninstall'])
	if install.returncode == 0:
		sendNotification('Successfully Uninstalled')
	else:
		sendNotification('ERROR: failed to uninstall')

def runDtbSetup():
	check = subprocess.run([util_script, 'check'])
	if check.returncode == 0:
		if Dialog().yesno(title, 'DTB file is already installed, do you want to uninstall?'):
			uninstallDtb()
	elif check.returncode == 3:
		sendNotification('ERROR: unsupported device')
	elif check.returncode == 2:
		ret = Dialog().yesnocustom(title, 'DTB file is installed but had a checksum missmatch', 'Uninstall', 'Cancel', 'Update', 30000)
		if ret == 1:
			installDtb()
		elif ret == 2:
			uninstallDtb()
	else:
		if Dialog().yesno(title, 'Install the DTB file?'):
			installDtb()

def main():
	cmd = sys.argv[1] if len(sys.argv) > 1 else None

	if cmd == "nespi":
		runDtbSetup()
		return

	# normal run
	ADDON.openSettings()

if __name__ == "__main__":
	main()
