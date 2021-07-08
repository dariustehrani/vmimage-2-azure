# vmimage-2-azure
converts ova and vmdk VM Images for the use with Azure.

## diagram
![alt text](/azure-image-converter.png)


##  related links

* https://docs.openstack.org/de/image-guide/convert-images.html  
* https://www.vmware.com/support/developer/ovf/  
* http://www.hurryupandwait.io/blog/creating-a-hyper-v-vagrant-box-from-a-virtualbox-vmdk-or-vdi-image  

### image cleansing
* https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-upload-generic
* https://docs.microsoft.com/de-de/azure/virtual-machines/windows/prepare-for-upload-vhd-image 

# VHD rightsizing
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-upload-generic#resizing-vhds

### Azure VHD utilities.
### This project provides a Go package to read Virtual Hard Disk (VHD) file, a CLI interface to upload local VHD to Azure storage and to inspect a local VHD.
*  https://github.com/microsoft/azure-vhd-utils


### iso 2 azure example
https://github.com/garvincasimir/Azure-ISO-To-VHD

### mount vhd in linux
https://stackoverflow.com/questions/36819474/how-can-i-attach-a-vhdx-or-vhd-file-in-linux

### stackoverflow discussion
https://superuser.com/questions/716649/how-to-change-fixed-size-vdi-with-modifyhd-command-in-windows