Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.Run("route -f")
		WshShell.Run("ipconfig /release")
		WshShell.Run("ipconfig /renew")
		WshShell.Run("arp -d *")
		WshShell.Run("nbtstat -R")
		WshShell.Run("nbtstat -RR")
		WshShell.Run("ipconfig /flushdns")
		WshShell.Run("ipconfig /registerdns")