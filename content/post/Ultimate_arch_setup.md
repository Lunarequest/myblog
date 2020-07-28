---
title: "Ultimate arch linux setup"
date: 2020-07-28T15:46:09+05:30
tags: [arch, linux, secureboot, plymouth]
draft: true
---
# Background
Recently after distro-hopping I decied that Arch linux was perfect for me and I really can't move to another distro. After installing Arch I went through a few extra steps to add some features like secure boot(I know, its not needed) and plymouth to add some fancy looks to my setup. __I am assuming you have used linux__.

## The Arch install
If you are seeing this after a couple of years after I publish it please follow the archwiki to have the most up to date instructions. To start with this you will need to download the [arch iso](https://www.archlinux.org/releng/releases/2020.07.01/torrent/) or create your own [ISO](https://wiki.archlinux.org/index.php/Remastering_the_Install_ISO)
If you make your own iso you configure it to use secureboot. If you are like me and don't want to make a custom iso disbale secure boot and boot the arch iso. You will need to make a bootable usb or cdrom.

Once you have booted this ISO you will need to install arch. I will be writing how I installed Arch you can do it however you feel comfortable. 

### Creating and formating the disk
I used the following partition map.
```
| Mount point | Partition | Partition Type            | Suggested size          |
|-------------|-----------|---------------------------|-------------------------|
| /mnt/boot   | /dev/sda1 | EFI system partition type | 512MB                   |
| /mnt        | /dev/sda2 | Linux x86-64 root (/)     | Remainder of the device |
|             |           |                           |                         | 
```
I use ext4 for the root partion and vfat for the boot partion.The more knowledgeable might of you have noticed that there is no swap partition That is because I used a swapfile. Making a swapfile is super simple and can be done at this point but before you do you need to format the partitions. These commands assume you use ext4. If you use btrfs you need to turn off CoW for the swapfile

```shell
$  dd if=/dev/zero of=/mnt/swapfile bs=1M count=512 status=progress
```
you will want to change count to the size of swap file you require. Next you will want to change the file permission to prevent the swapfile from being read by a text editor
```shell
$ chmod 600 /swapfile
```
After this you can format and activate the swapfile like a swap partition
```shell
$  mkswap /swapfile
$  swapon /swapfile
```
After this you will need to connect to the internet. Go through the Arch wiki if you need to use Wifi rather then a Ethernet cable. If you use Ethernet you may need to run `dhcpcd` to get a IP adress. At this point we can run the pacstarp command but pacstarp copies the mirror list from the iso. You may want to use `reflector` after installing it to get a faster download packages

```shell
$ pacstrap /mnt base linux linux-firmware nano vim man-db man-pages fish
```
You can skip fish if you don't like the fish shell. After this you will need to run the following command to genrate a fstab file. Check it for any errors and fix them. 
```shell
$ genfstab -U /mnt >> /mnt/etc/fstab
```
After this you will need to chroot(change root) to the /mnt folder using this command
```shell
arch-chroot /mnt
```
After this you will need to set the the timezone info using the following command. You can also sync your hardware clock.

```shell
$ ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
$ hwclock --systohc
```
Next edit `/etc/locale.gen` and uncomment `en_US.UTF-8`, `UTF-8` and other needed locales.Then run `locale-gen` to genrate the required locales. After this you can set the locale confing by running
```shell
$ nano /etc/locale.conf
```
and set your locale like so `LANG=en_US.UTF-8`. Next up we will need to setup the network configs.