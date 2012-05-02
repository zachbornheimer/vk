$adaptor = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.Name -like "*Wireless*"{
$adaptor.Disable()
$adaptor.Enable()