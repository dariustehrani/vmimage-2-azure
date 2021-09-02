#!/bin/bash

# fundamentals
sudo apt-get update && sudo apt-get dist-upgrade -y 
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl ca-certificates apt-transport-https lsb-release progress

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io


# qemu
sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager
sudo systemctl is-active libvirtd
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

# install packer & terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y packer terraform

# terraform autocomplete
touch ~/.bashrc
terraform -install-autocomplete

# azcli
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli blobfuse azcopy

# azcopy
curl -s -D- https://aka.ms/downloadazcopy-v10-linux | grep ^Location
wget -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux && tar -xf azcopy_v10.tar.gz --strip-components=1
sudo chown root:root azcopy
sudo mv azcopy /usr/local/bin/


# managed identity access  storage access
#https://techcommunity.microsoft.com/t5/azure-paas-blog/mount-blob-storage-on-linux-vm-using-managed-identities-or/ba-p/1821744

# blobfuse usage
sudo mkdir /mnt/resource/blobfusetmp -p
sudo chown $USER /mnt/resource/blobfusetmp
touch ~/fuse_connection.cfg
chmod 600 ~/fuse_connection.cfg

# fuse connection
accountName 4711vmstorage
authType MSI
containerName data

# create storage account 
# todo
assign "storage blob contributor" role to VM managed identity

mkdir /mnt/img-data
blobfuse /mnt/img-data --tmp-path=/mnt/resource/blobfusetmp  --config-file=/home/darius/fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120

# run qemu
cd /mnt/img-data
qemu-img convert -f vmdk -O vpc haproxy.ova.vmdk linux-haproxy.vhd & progress -mp $!

## unmount command for blobfuse
## fusermount -u /mnt/img-data


# from vmdk to raw
 qemu-img convert -f vmdk -O raw haproxy.ova.vmdk haproxyfixed.raw

#azcopy login
azcopy login --identity
azcopy copy /mnt/img-data/linux-haproxy.vhd 'https://4711vmstoragelrs.blob.core.windows.net/data/linux-haproxy2.vhd' --blob-type=PageBlob


#windows10 mount nfs
Enable-WindowsOptionalFeature -FeatureName ServicesForNFS-ClientOnly, ClientForNFS-Infrastructure -Online -NoRestart

mount -o 4711vmimagenfs.blob.core.windows.net:/4711vmimagenfs/data X: