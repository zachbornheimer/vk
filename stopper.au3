
HotKeySet("{ESC}", "killer")
while ProcessExists("viruskiller.exe")
   Local $list = ProcessList()
For $i = 1 To $list[0][0]
	if ($list[$i][0] <> "taskmgr.exe" AND $list[$i][0] <> "fixtime.exe" AND $list[$i][0] <> "progSafteyDiagnostic.exe" AND $list[$i][0] <> "stopper.exe" AND $list[$i][0] <> "viruskiller.exe" AND $list[$i][0] <> "mbam-setup.exe" AND $list[$i][0] <> "mbam-setup.tmp" AND $list[$i][0] <> "mbam.exe" AND $list[$i][0] <> "svchost.exe" AND $list[$i][1] <> "System" AND $list[$i][1] <> "System Idle Process" AND $list[$i][0] <> "smss.exe" AND $list[$i][0] <> "csrss.exe" AND $list[$i][0] <> "winlogon.exe" AND $list[$i][0] <> "services.exe" AND $list[$i][0] <> "lsass.exe") Then
		ProcessClose($list[$i][1])
	EndIf
Next
Sleep(500)
wend
Run("explorer.exe")
func killer()
Exit
EndFunc