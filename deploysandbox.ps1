#Azure Sandbox Deployment Script

#Create Downloads Folder

$targetFolder='DownloadFiles'

New-Item -Type Directory -Path 'c:\\' -Name td -Force

#Download Burpsuite
if (-Not (Test-Path c:\\td\\burpsuite.exe)) {
    invoke-webrequest -uri 'https://portswigger-cdn.net/burp/releases/download?product=community&version=2024.6.6&type=WindowsX64' -OutFile 'c:\\td\\burpsuite.exe'
}

#Install Burpsuite
if (-Not(Test-Path $env:USERPROFILE\AppData\Local\BurpSuiteCommunity\BurpSuiteCommunity.exe)) {
   c:\\td\\burpsuite.exe -q -c
}
