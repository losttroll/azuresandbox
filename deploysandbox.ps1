cls
#Azure Sandbox Deployment Script
Write-Host "Building Sandbox"

#Create Downloads Folder
if (-Not (Test-Path c:\\td)) {
    Write-Host "Creating td folder"
    New-Item -Type Directory -Path 'c:\\' -Name td -Force
    
}


#Download Burpsuite
if (-Not (Test-Path c:\\td\\burpsuite.exe)) {
    Write-Host "Downloading Burpsuite Community"
    invoke-webrequest -uri 'https://portswigger-cdn.net/burp/releases/download?product=community&version=2024.6.6&type=WindowsX64' -OutFile 'c:\\td\\burpsuite.exe'
}

#Install Burpsuite
if (-Not(Test-Path $env:USERPROFILE\AppData\Local\BurpSuiteCommunity\BurpSuiteCommunity.exe)) {
   Write-Host "Installing Burpsuite Community"
   c:\\td\\burpsuite.exe -q -c
}

#Download Notepad++
if (-Not (Test-Path c:\\td\\notepadplusplus.exe)) {
    Write-Host "Downloading Notepad++"
    invoke-webrequest -uri 'https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.7/npp.8.6.7.Installer.x64.exe' -OutFile 'c:\\td\\notepadplusplus.exe'
}

#Install Notepad++
if (-Not(Test-Path "C:\\Program Files\\Notepad++\\notepad++.exe")) {
   Write-Host "Installing Notepad++"
   c:\\td\\notepadplusplus.exe /S
}

#Sysinternals link - https://download.sysinternals.com/files/SysinternalsSuite.zip


#Download SysInternals
if (-Not (Test-Path c:\\td\\SysinternalsSuite.zip)) {
    Write-Host "Downloading SysInternals"
    invoke-webrequest -uri 'https://download.sysinternals.com/files/SysinternalsSuite.zip' -OutFile 'c:\\td\\SysinternalsSuite.zip'
}

#Extract SysInternals
if (-Not (Test-Path  "c:\\td\\SysInternals")) {
    write-host "Extracting Sysinternals to: c:\\td\\SysInternals"
    Expand-Archive -LiteralPath 'c:\\td\\SysinternalsSuite.zip' -DestinationPath c:\\td\\SysInternals\\SysInternals
}

#Extract SysInternals
if (-Not (Test-Path  "$env:USERPROFILE\\Desktop\\SysInternals")) {
    write-host "Copying Sysinternals to: $env:USERPROFILE\SysInternals"
    Copy-Item -Recurse -LiteralPath 'c:\\td\\SysInternals' -Destination $env:USERPROFILE\Desktop\\
}

#https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml

#Download Sysmon Config
if (-Not (Test-Path c:\\td\\sysmonconfig.xml)) {
    Write-Host "Downloading Sysmon Config"
    invoke-webrequest -uri 'https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml' -OutFile c:\\td\\sysmonconfig.xml
}

#Install Sysmon
if (-Not (Test-Path C:\\Windows\\sysmon.exe)) {
    Write-Host "Installing Sysmon"
    C:\td\SysInternals\SysInternals\\Sysmon.exe -i c:\td\sysmonconfig.xml
}


#https://7-zip.org/a/7z2408-x64.msi
#Download Sysmon Config
if (-Not (Test-Path c:\\td\\7zip.msi)) {
    Write-Host "Downloading 7zip"
    invoke-webrequest -uri 'https://7-zip.org/a/7z2408-x64.msi' -OutFile c:\\td\\7zip.msi
}

#Install 7zip
if (-Not (Test-Path "C:\\Program Files\\7-Zip\\7z.exe")) {
    Write-Host "Installing 7zip"
     C:\td\7zip.msi /quiet
}


write-host Completed
