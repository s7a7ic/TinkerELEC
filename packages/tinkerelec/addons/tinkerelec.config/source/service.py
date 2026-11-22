import xbmc
from default import applyConfig

class Monitor(xbmc.Monitor):
	def onSettingsChanged(self):
		applyConfig('profile')

if __name__ == '__main__':
	Monitor().waitForAbort()
