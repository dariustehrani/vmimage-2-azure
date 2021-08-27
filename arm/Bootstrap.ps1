#Images
$imageurl = $args[0]
$desturl = $args[1]

#Force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Assign Packages to Install
$Packages = '7zip',`
            'curl',
	        'azcopy10',
            'vcredist2015'

#Install Packages
ForEach ($PackageName in $Packages)
{choco install $PackageName -y}

#Install StarwindConverter
D: 
C:\ProgramData\chocolatey\bin\curl.exe -k https://www.starwindsoftware.com/tmplink/starwindconverter.exe -o starwindconverter.exe
D:\starwindconverter.exe /silent

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
C:\ProgramData\chocolatey\bin\curl.exe -k -L "$imageurl" -o image.ova

#Extract OVA Image
C:\ProgramData\chocolatey\bin\7z.exe x *ova*

#Convert Image
Get-ChildItem -Path F:\ -Filter *.vmdk | ForEach-Object { 
Invoke-Expression "& 'C:\Program Files\StarWind Software\StarWind V2V Converter\V2V_ConverterConsole.exe' convert in_file_name=F:\$_ out_file_name=F:\$_.vhd out_file_type=ft_vhd_thick" 
$size = [math]::ceiling(((Get-Item F:\$_.vhd).length/1MB))
New-Item "F:\diskpart.txt" -ItemType File -Value "select vdisk file=`"F:\$_.vhd`" `r`nexpand vdisk maximum=$size" -Force
C:\Windows\System32\diskpart.exe /s F:\diskpart.txt
C:\ProgramData\chocolatey\bin\azcopy.exe copy F:\$_.vhd "$desturl"
}
