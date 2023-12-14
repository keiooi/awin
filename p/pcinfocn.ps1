$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
chcp 65001
#chcp 936
#Set-ExecutionPolicy RemoteSigned #开启运行权
#cmd下运行:PowerShell.exe -ExecutionPolicy Bypass -File xxx.ps1

#Get-CimInstance(更好)=Get-WMIObject
Write-Host "电脑信息"
Write-Host "-----------------------"
Write-Host "----------CPU-------------"
Write-Host "-----------------------"
$cpu=Get-CimInstance -Class Win32_Processor
Write-Host "名称：$($cpu.Name) "
Write-Host "厂商：$($cpu.Manufacturer)   说明：$($cpu.Caption) "
Write-Host "二级缓存：$($cpu.L2CacheSize/1000) M 三级缓存：$($cpu.L3CacheSize/1000) M"
Write-Host "频率：$($cpu.MaxClockSpeed/1000) GHz 核心：$($cpu.NumberOfCores)  线程：$($cpu.ThreadCount) "
Write-Host "-----------------------"
Write-Host "----------BIOS-------------"
Write-Host "-----------------------"
$bios=Get-CimInstance -Class Win32_BIOS
Write-Host "名称：$($bios.Name) "
Write-Host "厂商：$($bios.Manufacturer) "
Write-Host "-----------------------"
Write-Host "----------MEMORY-------------"
Write-Host "-----------------------"
$memory=Get-CimInstance -Class Win32_PhysicalMemory
foreach($mem in $memory){
Write-Host "名称：$($mem.Name)  说明：$($mem.Caption) "
Write-Host "厂商：$($mem.Manufacturer) "
Write-Host "大小：$($mem.Capacity/1024/1024/1024) G 频率：$($mem.Speed) "
if($mem.MemoryType -ne 0){
if($mem.MemoryType -eq 24){
Write-Host "接口:DDR3"
}
if($mem.MemoryType -eq 26){
Write-Host "接口:DDR4"
}
if($mem.MemoryType -eq 34){
Write-Host "接口:DDR5"
}
}else{
if($mem.SMBIOSMemoryType -eq 24){
Write-Host "接口:DDR3"
}
if($mem.SMBIOSMemoryType -eq 26){
Write-Host "接口:DDR4"
}
if($mem.SMBIOSMemoryType -eq 34){
Write-Host "接口:DDR5"
}
}
Write-Host "类型：$($mem.MemoryType) SMBIOS类型：$($mem.SMBIOSMemoryType) "
Write-Host "-----------------------"
}
Write-Host "-----------------------"
Write-Host "----------DISK-------------"
Write-Host "-----------------------"
$disk=Get-CimInstance -Class Win32_DiskDrive
foreach($d in $disk){
Write-Host "名称：$($d.Name) 说明：$($d.Caption) "
Write-Host "描述：$($d.Description) 类型：$($d.MediaType)"
Write-Host "接口：$($d.InterfaceType)  分区：$($d.Partitions) "
Write-Host "容量：$('{0:f2}' -f($d.Size/1024/1024/1024)) G"
Write-Host "-----------------------"
}
Write-Host "-----------------------"
Write-Host "----------BOARD-------------"
Write-Host "-----------------------"
$board=Get-CimInstance -Class Win32_BaseBoard
Write-Host "名称：$($board.Name)  厂商：$($board.Manufacturer) "
Write-Host "product：$($board.Product) SerialNumber：$($board.SerialNumber)  "
Write-Host "版本：$($board.Version) "
Write-Host "-----------------------"
Write-Host "----------OperratingSYS-------------"
Write-Host "-----------------------"
$opsys=Get-CimInstance -Class Win32_OperatingSystem
Write-Host "系统：$($opsys.Caption)  $($opsys.OSArchitecture) "
Write-Host "版本：$($opsys.Version) "
Write-Host "设备：$($opsys.CSName) "
Write-Host "用者：$($opsys.RegisteredUser) "
Write-Host "-----------------------"
Write-Host "----------IP-------------"
Write-Host "-----------------------"
$ips=Get-CimInstance -Class Win32_NetworkAdapterConfiguration
foreach($ip in $ips){
if($ip.IPAddress){
Write-Host "说明：$($ip.Description) "
Write-Host "DHCP：$($ip.DHCPEnabled) "
Write-Host "IP：$($ip.IPAddress) "
Write-Host "Gateway：$($ip.DefaultIPGateway) "
Write-Host "IPSubnet：$($ip.IPSubnet)  "
Write-Host "DNS：$($ip.DNSServerSearchOrder) "
Write-Host "-----------------------"
}
}
$isact=Read-Host "（Y/N）查看系统激活状态"
if($isact -eq "Y")
{
slmgr /xpr
}
pause