#Force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Assign Packages to Install
$Packages = '7zip',`
            'wget',
	        'azcopy10'

#Install Packages
ForEach ($PackageName in $Packages)
{choco install $PackageName -y}

D: 
C:\ProgramData\chocolatey\bin\wget.exe https://www.starwindsoftware.com/tmplink/starwindconverter.exe
starwindconverter.exe /silent
