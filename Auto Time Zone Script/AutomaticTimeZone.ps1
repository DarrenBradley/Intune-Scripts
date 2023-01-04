##################################################################################################
<#
Version: 1.0
Author: Darren Bradley
Description: Sets Automatic Time Based on Location
Needs addtional policy to enable location services for apps

Run Script using logged on : No
Enforce Signature : No
Run in 64 Bit : Yes

Release notes:
Version 1.0: Original published version. 

#>
###################################################################################################

Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location -Name Value -Value "Allow"
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate -Name start -Value "3"