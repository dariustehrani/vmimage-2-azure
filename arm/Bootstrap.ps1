#Force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Assign Packages to Install
$Packages = '7zip',`
            'wget',
	        'azcopy10',
            'base64'

#Install Packages
ForEach ($PackageName in $Packages)
{choco install $PackageName -y}

#Install StarwindConverter
D: 
C:\ProgramData\chocolatey\bin\wget.exe https://www.starwindsoftware.com/tmplink/starwindconverter.exe
D:\starwindconverter.exe /silent
"C:\Program Files\StarWind Software\StarWind V2V Converter\vc\vc_redist.x64.140.exe" /quiet

#Initialise Data Discs
$disks = Get-Disk | Where partitionstyle -eq 'raw' | sort number

$letters = 70..89 | ForEach-Object { [char]$_ }
$count = 0
$labels = "data1","data2"

foreach ($disk in $disks) {
    $driveLetter = $letters[$count].ToString()
    $disk |
    Initialize-Disk -PartitionStyle MBR -PassThru |
    New-Partition -UseMaximumSize -DriveLetter $driveLetter |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel $labels[$count] -Confirm:$false -Force
$count++
}

#Download OVA Image
F:
Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/instance/compute/userData?api-version=2021-01-01&format=text" | C:\ProgramData\chocolatey\bin\base64 -d | C:\ProgramData\chocolatey\bin\wget.exe -i -

#Extract OVA Image
C:\ProgramData\chocolatey\bin\7z.exe x *ova*
