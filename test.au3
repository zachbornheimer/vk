#RequireAdmin
AutoItSetOption("ExpandEnvStrings", 1)

Run("stopper.exe")

While 1
    $ping_result = Ping("zysys.org")
    if $ping_result > 0 Then
    	;MsgBox(0, "Internet!", "You have internet.  Initializing procedure Gamma Delta Omicron.", 3)
    	fixtime()
                $items = listStartupItems()
    	for $i = 1 to UBound($items) - 1
    	   ;MsgBox(0, "Startup Items", $items[$i])
    	Next
    	ExitLoop
    Else
    	;MsgBox(0, "No Internet!", "You do not have internet.  Initializing procedure Beta Pi Epsilon.", 3)
    	internetFix()
    Endif
WEnd

;fixtime()
mbamDownload()

MsgBox(0, '!!!', "Install Malwarebytes' Anti-Malware", 3);
RunWait("mbam-setup.exe")
MsgBox(0, '!!!', "Update the software (update tab), then run a Quick Scan", 3);
RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce", "CCleaner", "REG_SZ", @WorkingDir&"\finisher.exe")
MsgBox(0, '!!!', "Keep this device in the computer after completion", 3)
MsgBox(0, '!!!', "When you restart, log in again.  The computer will launch CCleaner.  Run the registry cleaner componant.", 3);
RunWait("%ProgramFiles%\Malwarebytes' Anti-Malware\mbam.exe")

func mbamDownload()
    RunWait("getmbam.exe")
EndFunc


func listStartupItems()
Dim $keys[1], $i
$i = 1
   While 1
      Local $regpath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
      Local $var = RegEnumVal($regpath, $i)
      Local $path = RegRead($regpath, $var)
      Local $pathArray = StringSplit($path, '\')
      If @error <> 0 Then ExitLoop
      Local $bound = UBound($keys)
      ReDim $keys[$bound + 1]
      $keys[$bound] = $pathArray[UBound($pathArray) - 1]
      checkItem($keys[$bound], $var, $regpath)
      $i += 1
   WEnd
   $i = 1
   While 1
      Local $regpath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
      Local $var = RegEnumVal($regpath, $i)
      Local $path = RegRead($regpath, $var)
      Local $pathArray = StringSplit($path, '\')
      If @error <> 0 Then ExitLoop
      Local $bound = UBound($keys)
      ReDim $keys[$bound + 1]
      $keys[$bound] = $pathArray[UBound($pathArray) - 1]
      checkItem($keys[$bound], $var, $regpath)
      $i += 1
   WEnd
   $i = 1
   While 1
      Local $regpath = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
      Local $var = RegEnumVal($regpath, $i)
      Local $path = RegRead($regpath, $var)
      Local $pathArray = StringSplit($path, '\')
      If @error <> 0 Then ExitLoop
      Local $bound = UBound($keys)
      ReDim $keys[$bound + 1]
      $keys[$bound] = $pathArray[UBound($pathArray) - 1]
      checkItem($keys[$bound], $var, $regpath)
      $i += 1
   WEnd
   $i = 1
   While 1
      Local $regpath = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce"
      Local $var = RegEnumVal($regpath, $i)
      Local $path = RegRead($regpath, $var)
      Local $pathArray = StringSplit($path, '\')
      If @error <> 0 Then ExitLoop
      Local $bound = UBound($keys)
      ReDim $keys[$bound + 1]
      $keys[$bound] = $pathArray[UBound($pathArray) - 1]
      checkItem($keys[$bound], $var, $regpath)
      $i += 1
   WEnd
   return $keys
EndFunc

func checkItem($program, $key, $path)
   if RunWait('progSafteyDiagnostic.exe ' & $program) == 2 Then
      RegDelete($path, $key)
      MsgBox(0, "Removal", "Removed " & $program, 3)
   EndIf
EndFunc

func fixtime()
    MsgBox(0, "Time", "Fixing your Clock...Please be patient.", 4)
    RunWait('fixtime.exe date')
    $date = FileReadLine("date")
    RunWait('fixtime.exe time')
    $time = FileReadLine("time")
    $date = StringSplit($date, "")
    $time = StringSplit($time, "")
    ; Note, to prevent loss of a front zero, a 1 is prepended to the date/time strings
    ; it is also done to obscure the data.
    $date = $date[2] & $date[3] & '/' & $date[4] & $date[5] & '/' & $date[6] & $date[7]
    $time = $time[2] & $time[3] & ':' & $time[4] & $time[5] & ':' & $time[6] & $time[7]
    $datecmd = 'date ' & $date
    Run(@ComSpec & ' /k date ' & $date, '', @SW_HIDE)
    Run(@ComSpec & ' /k time ' & $time, '', @SW_HIDE)
    FileDelete("date")
    FileDelete("time")
    RunWait("w32tm /resync", '', @SW_DISABLE)
EndFunc

func repairInternet()
    RunWait("route -f")
    RunWait("ipconfig /release")
    RunWait("ipconfig /renew")
    RunWait("arp -d *")
    RunWait("nbtstat -R")
    RunWait("nbtstat -RR")
    RunWait("ipconfig /flushdns")
    RunWait("ipconfig /registerdns")
EndFunc


func internetFix()
    fixLanSettings()
    repairInternet()
EndFunc

func fixLanSettings()

;*************************************************************************
; This Subroutine modified by Z. Bornheimer from 
; the script originally designed by:
; Tonnie van Gennip - 20061110
;
;*************************************************************************
; Start of script
;
; Get the SID of the currently logged on user
;
$WMI = ObjGet("winmgmts://./root/cimv2")
$User = $WMI.Get("Win32_UserAccount.Domain='" & @LogonDomain & "'" & ",Name='" & @UserName & "'")
$UserSID = $User.SID
$ProxyOverride = ""
$ProxyServer = ""
$CurrentUser_ProxyOverrideSetting = RegRead("HKEY_USERS\" & $UserSID & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyOverride")
RegWrite("HKEY_USERS\" & $UserSID & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyOverride", "REG_SZ", $ProxyOverride)
$CurrentUser_ProxyServerSetting = RegRead("HKEY_USERS\" & $UserSID & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer")
RegWrite("HKEY_USERS\" & $UserSID & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer", "REG_SZ", $ProxyServer)
$HKCU_ProxyOverrideSetting = RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyOverride")
RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyOverride", "REG_SZ", $ProxyOverride)
$HKCU_ProxyServerSetting = RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer")
RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer", "REG_SZ", $ProxyServer)
$proxyenablesetting = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable")
RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "DWORD", "00000000")
$autoconfigurl = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "AutoConfigURL")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "AutoConfigURL")
;$autodetectsettings = RegRead("HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\Control Panel", "AutoConfig")
;RegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\Control Panel", "AutoConfig", "DWORD", "00000000")
; HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections
; 9th Entry in DefaultConnectionSettings...set to 00
;
; End of script
;MsgBox(0,'',RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections", "DefaultConnectionSettings"))
Exit
EndFunc
