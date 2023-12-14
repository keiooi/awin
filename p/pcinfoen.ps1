$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
chcp 65001
#chcp 936
#Set-ExecutionPolicy RemoteSigned #开启运行权
#cmd下运行:PowerShell.exe -ExecutionPolicy Bypass -File xxx.ps1

#Get-CimInstance(更好)=Get-WMIObject
Write-Host "Computer Message"
Write-Host "-----------------------"
Write-Host "----------CPU-------------"
Write-Host "-----------------------"
$cpu=Get-CimInstance -Class Win32_Processor
Write-Host "Name:$($cpu.Name) "
Write-Host "Manufacturer:$($cpu.Manufacturer) | Caption:$($cpu.Caption) "
Write-Host "2CacheSize:$($cpu.L2CacheSize/1000)M | 3CacheSize:$($cpu.L3CacheSize/1000)M"
Write-Host "Speed:$($cpu.MaxClockSpeed/1000)GHz | Cores:$($cpu.NumberOfCores) | ThreadCount:$($cpu.ThreadCount) "
Write-Host "-----------------------"
Write-Host "----------BIOS-------------"
Write-Host "-----------------------"
$bios=Get-CimInstance -Class Win32_BIOS
Write-Host "Name:$($bios.Name) "
Write-Host "Manufacturer:$($bios.Manufacturer) "
Write-Host "-----------------------"
Write-Host "----------MEMORY-------------"
Write-Host "-----------------------"
$memory=Get-CimInstance -Class Win32_PhysicalMemory
foreach($mem in $memory){
Write-Host "Name:$($mem.Name) | Caption:$($mem.Caption) "
Write-Host "Manufacturer:$($mem.Manufacturer) "
Write-Host "Size:$($mem.Capacity/1024/1024/1024)G | Speed:$($mem.Speed) "
if($mem.MemoryType -ne 0){
if($mem.MemoryType -eq 24){
Write-Host "InterfaceType:DDR3"
}
if($mem.MemoryType -eq 26){
Write-Host "InterfaceType:DDR4"
}
if($mem.MemoryType -eq 34){
Write-Host "InterfaceType:DDR5"
}
}else{
if($mem.SMBIOSMemoryType -eq 24){
Write-Host "InterfaceType:DDR3"
}
if($mem.SMBIOSMemoryType -eq 26){
Write-Host "InterfaceType:DDR4"
}
if($mem.SMBIOSMemoryType -eq 34){
Write-Host "InterfaceType:DDR5"
}
}
Write-Host "MemoryType:$($mem.MemoryType) | SMBIOSMemoryType:$($mem.SMBIOSMemoryType) "
Write-Host "-----------------------"
}
Write-Host "-----------------------"
Write-Host "----------DISK-------------"
Write-Host "-----------------------"
$disk=Get-CimInstance -Class Win32_DiskDrive
foreach($d in $disk){
Write-Host "Name:$($d.Name) | Caption:$($d.Caption) "
Write-Host "Description:$($d.Description) | MediaType:$($d.MediaType) "
Write-Host "InterfaceType:$($d.InterfaceType) | Partitions:$($d.Partitions) "
Write-Host "Size:$('{0:f2}' -f($d.Size/1024/1024/1024))G"
Write-Host "-----------------------"
}
Write-Host "-----------------------"
Write-Host "----------BOARD-------------"
Write-Host "-----------------------"
$board=Get-CimInstance -Class Win32_BaseBoard
Write-Host "Name:$($board.Name) | Manufacturer:$($board.Manufacturer) "
Write-Host "Product:$($board.Product) | SerialNumber:$($board.SerialNumber)  "
Write-Host "Version:$($board.Version) "
Write-Host "-----------------------"
Write-Host "----------OperratingSYS-------------"
Write-Host "-----------------------"
$opsys=Get-CimInstance -Class Win32_OperatingSystem
Write-Host "System:$($opsys.Caption)  $($opsys.OSArchitecture) "
Write-Host "Version:$($opsys.Version) "
Write-Host "PcName:$($opsys.CSName) "
Write-Host "Name:$($opsys.RegisteredUser) "
Write-Host "-----------------------"
Write-Host "----------IP-------------"
Write-Host "-----------------------"
$ips=Get-CimInstance -Class Win32_NetworkAdapterConfiguration
foreach($ip in $ips){
if($ip.IPAddress){
Write-Host "Description:$($ip.Description) "
Write-Host "DHCP:$($ip.DHCPEnabled) "
Write-Host "IP:$($ip.IPAddress) "
Write-Host "Gateway:$($ip.DefaultIPGateway) "
Write-Host "IPSubnet:$($ip.IPSubnet)  "
Write-Host "DNS:$($ip.DNSServerSearchOrder) "
Write-Host "-----------------------"
}
}
$isact=Read-Host "(Y/N)View system activation status"
if($isact -eq "Y")
{
slmgr /xpr
}
pause