$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://keiooi.github.io/awin/p/stpwinupdate/stopupdate.cmd'
$DownloadURL2 = 'https://keioi.gitee.io/pc/p/stpwinupdate/startupdate.cmd'

$rand = Get-Random -Maximum 1000
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\stpw_$rand.cmd" } else { "$env:TEMP\stpw_$rand.cmd" }
$isact=Read-Host "（1/2）关闭/开启win更新:"
if($isact -eq "1") {
    $response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
}
if($isact -eq "2") {
    $response = Invoke-WebRequest -Uri $DownloadURL2 -UseBasicParsing
}

$ScriptArgs = "$args "
$prefix = "@REM $rand `r`n"
$content = $prefix + $response
Set-Content -Path $FilePath -Value $content

Start-Process $FilePath $ScriptArgs -Wait

$FilePaths = @("$env:TEMP\stpw*.cmd", "$env:SystemRoot\Temp\stpw*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
