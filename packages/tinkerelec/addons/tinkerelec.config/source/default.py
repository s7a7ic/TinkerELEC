import os.path
import subprocess
import sys
import xbmc
import xbmcaddon
from xbmcgui import Dialog

ADDON = xbmcaddon.Addon()
ADDON_BIN_DIR = os.path.join(ADDON.getAddonInfo('path'), 'bin')
dtb_script = os.path.join(ADDON_BIN_DIR, 'nespi-dtb-install')
config_script = os.path.join(ADDON_BIN_DIR, 'tinkerelec-config')
ICON = ADDON.getAddonInfo('icon')

dtb_title = 'NesPi+ DTB Installer'

def sendNotification(message):
	xbmc.executebuiltin('Notification(%s, %s, %d, %s)'%(dtb_title, message, 5000, ICON))

def askForReboot(title):
	if Dialog().yesno(title, 'A reboot is required for the changes to take effect.\nReboot now?'):
		subprocess.call('reboot')

def runDtbScript(action):
	script = subprocess.run([dtb_script, action])
	if script.returncode == 0:
		askForReboot(f'DTB file {action}ed')
	else:
		sendNotification(f'ERROR: failed to {action}')

def runDtbSetup():
	check = subprocess.run([dtb_script, 'check'])
	if check.returncode == 0:
		if Dialog().yesno(dtb_title, 'DTB file is already installed, do you want to uninstall?'):
			runDtbScript('uninstall')
	elif check.returncode == 3:
		sendNotification('ERROR: unsupported device')
	elif check.returncode == 2:
		ret = Dialog().yesnocustom(dtb_title, 'DTB file is installed but had a checksum missmatch', 'Uninstall', 'Cancel', 'Update', 30000)
		if ret == 1:
			runDtbScript('install')
		elif ret == 2:
			runDtbScript('uninstall')
	else:
		if Dialog().yesno(dtb_title, 'Install the DTB file?'):
			runDtbScript('install')

def applyConfig(action):
	subprocess.call([config_script, action])
	askForReboot('Configuration applied')

def main():
	cmd = sys.argv[1] if len(sys.argv) > 1 else None

	if cmd == "nespi":
		runDtbSetup()
		return

	if cmd == "config":
		applyConfig('files')
		return

	# normal run
	ADDON.openSettings()

if __name__ == "__main__":
	main()
