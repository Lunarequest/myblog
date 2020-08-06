---
title: "Ultimate arch linux setup"
date: 2020-07-28T15:46:09+05:30
tags: [arch, linux, secureboot, plymouth]
draft: false
---
# Background
Recently after distro-hopping I came back to Arch linux. It was perfect for me and I really can't move to another distro without missing the AUR. After installing Arch I went through a few extra steps to add some features like secure boot(I know its not needed) and plymouth to add m to my setup. __I am assuming you have used linux this does not and will not replace the arch wiki__.

## The Arch install
If you are seeing this after a couple of years after I publish it please follow the archwiki to have the most up to date instructions. To start with this you will need to download the [arch iso](https://www.archlinux.org/releng/releases/2020.07.01/torrent/) or create your own [ISO](https://wiki.archlinux.org/index.php/Remastering_the_Install_ISO)
If you make your own iso you configure it to use secureboot. If you are like me and don't want to make a custom iso disbale secure boot and boot the arch iso. You will need to make a bootable usb or cdrom.

Once you have booted this ISO you will need to install arch. I will be writing how I installed Arch you can do it however you feel comfortable I also assume you use systemd as your bootloader. If you use grub or anyother bootloader refer to the wiki on how to set things up for the bootloader

I have used the following partition map.
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
$ pacstrap /mnt base linux linux-firmware nano vim man-db man-pages fish sudo
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
and set your locale like so `LANG=en_US.UTF-8`. Next up we will need to setup the network configs. You will need to create a  hostname. __This will show up in certain prompts so chose wisely...__

```shell
nano /etc/hostname
```
Enter your hostname and save the file. Next up we need to create a hosts file. This assgins IPs to terms like localhost.

```shell
$ nano /etc/hosts
```
Copy the following into the file and save it
```hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	myhostname.localdomain	myhostname
```
Replace `127.0.1.1` with a static IP if you whish to use that over a dynamicly assinged IP.
At this point we need to install a bootloader. I chose systemd because even though setting it up is complex it is more powerful than any other bootloader(in my opinon). To kick of the process run 
```shell 
$  bootctl install
```
Run 
```shell
$ nano /boot/loader/loader.conf
```
and copy the following in your text editor and save the file.
```
default  arch
timeout  0
console-mode keep
editor   no
```
You can keep change the `editor  no` to `editor yes` if your system doesn't run the risk of being phsyically attacked. Eh who am I kidding if you need secure boot you sure as hell can't have people edit the bootloader configs.Next up we need to create a arch.conf. 
```shell
$ nano //boot/loader/entries/arch.conf
```
Add the following lines. We will revist this later.
```
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root="UUID=your uuid" rw 
``` 
to get the uuid you can run `blkid` and redirct the input to the file.
Next up we need to install a DE. I used Kde plasma but you can use anything you want to. Some of the later steps will need to be changed. Installing kde plasma is fairly simple. Depeneding on the amount of configartion you want to do you can chose how many packages you want. I choose all becuase I wasn't intreasted in heavy configaration. 
```shell
$ pacman -S plasma
```

After this we need to allow sddm to start up on boot. The following command should allow this to happen
```shell
systemctl enable sddm
```
After this you need to create a unprivallged account
```shell 
$ useradd -m -G -s /usr/bin/fish username
```
feel free to change the login shell to any one you prefer. Next up we need to set a password for the root and newly created account
```shell
$ passwd
$ passwd username
```
After this follow this [guide](https://linuxhint.com/add_users_arch_linux/) and setup the sudoers file. 
At this point we could reboot but there are a few things we should add before we reboot.
```shell 
$ pacman -S git konsole firefox
```
you can reboot now and hopefully you have a working arch install. If you don't. Start again.

## Secure boot
I am using custom keys and have wiped the microsoft keys of my system for better security. If you want to keep these keys you will need to use preboot/shim. Look into the arch wiki on how to use them.
To start off we need to install `efitools`
```shell
$ sudo pacman -S efitools
```
I accutuly did everything here in a folder I created. The path is `/etc/secure-boot/`. I recomand doing the same. First we create a GUID
```shell
$ uuidgen --random > GUID.txt
```
next up we create a Platform key
```shell
$ openssl req -newkey rsa:4096 -nodes -keyout PK.key -new -x509 -sha256 -days 3650 -subj "/CN=my Platform Key/" -out PK.crt
$ openssl x509 -outform DER -in PK.crt -out PK.cer
$ cert-to-efi-sig-list -g "$(< GUID.txt)" PK.crt PK.esl
$ sign-efi-sig-list -g "$(< GUID.txt)" -k PK.key -c PK.crt PK PK.esl PK.auth
$ sign-efi-sig-list -g "$(< GUID.txt)" -c PK.crt -k PK.key PK /dev/null rm_PK.auth # this is to allow the key to be removed in the future
```
Next the Key exchange key or KEK

```shell
$ openssl req -newkey rsa:4096 -nodes -keyout KEK.key -new -x509 -sha256 -days 3650 -subj "/CN=my Key Exchange Key/" -out KEK.crt
$ openssl x509 -outform DER -in KEK.crt -out KEK.cer
$ cert-to-efi-sig-list -g "$(< GUID.txt)" KEK.crt KEK.esl
$ sign-efi-sig-list -g "$(< GUID.txt)" -k PK.key -c PK.crt KEK KEK.esl KEK.auth
```
Finally the Signature Database key.

```shell
$ openssl req -newkey rsa:4096 -nodes -keyout db.key -new -x509 -sha256 -days 3650 -subj "/CN=my Signature Database key/" -out db.crt
$ openssl x509 -outform DER -in db.crt -out db.cer
$ cert-to-efi-sig-list -g "$(< GUID.txt)" db.crt db.esl
$ sign-efi-sig-list -g "$(< GUID.txt)" -k KEK.key -c KEK.crt db db.esl db.auth
```
Now we need to sign the kernels and efi binaries.
```shell
$ sudo sbsign --key db.key --cert db.crt --output /boot/vmlinuz-linux /boot/vmlinuz-linux
$ sudo sbsign --key db.key --cert db.crt --output esp/EFI/BOOT/BOOTX64.EFI esp/EFI/BOOT/BOOTX64.EFI
```
You will need to do this everytime you update the kernel or bootloader. I used a pacman hook to do this.
```shell
$ sudo nano /etc/pacman.d/hooks/99-secureboot.hook
```
My hook is the following
```
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux
Target = systemd

[Action]
Description = Signing Kernel for SecureBoot
When = PostTransaction
Exec = /usr/bin/sh -c "/usr/bin/find /boot/ -type f \( -name 'vmlinuz-*' -o -name 'systemd*' \) -exec /usr/bin/sh -c 'if ! /usr/bin/sbverify --list {} 2>/dev/null | /usr/bin/grep -q \"signature certificates\"; then /usr/bin/sbsign --key /etc/secure-boot/db.key --cert /etc/secure-boot/db.crt --output {} {}; fi' \;"
Depends = sbsigntools
Depends = findutils
Depends = grep
```
You should also copy all the keys to the /boot partion.
Next you need to put your  firmware into setup mode and enroll the keys. You can follow this guide on how to [enroll the keys](www.rodsbooks.com/efi-bootloaders/controlling-sb.html#setuputil).

## Plymouth
Fist we need to install a aur helper. I prefer yay but you can use any helper or manully git clone and `makepkg` each package on your own.

```shell
$ git clone https://aur.archlinux.org/yay.git
```
These packages are a must if you want to install any aur package.
```shell
$ sudo pacman -S fakeroot binuitls
```
Next to build and install yay. run these commands
```shell
$ makepkg -si
```
After this we can install plymouth.
```shell
$ yay plymouth
```
You can install the git or stable version. Next you need to edit the `/etc/mkinitcpio.conf`.
```shell
$ sudo nano /etc/mkinitcpio.conf 
```
you need to add the plymouth hook to the HOOKS section `HOOKS=(base udev plymouth ...)`. You might also need to add your drivers kernel module. 

At this point its time to get a theme for the plymouth screen. I used this [theme](https://aur.archlinux.org/packages/plymouth-theme-darth-vader-git/). However you can use the one you perfer.

You can get a list of choices using the following command
```shell
$ plymouth-set-default-theme -l
```
Finally to set the theme run 
```shell 
$ sudo  plymouth-set-default-theme -R theme
```
Add this to the options line in the arch.conf in the /boot partition. `quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0`
After this you can reboot the system and you should have your theme shown when you boot up.

## Final thoughts
I know it was a bit long but I spent a long time fixing issues and getting things working. I really enjoy arch and I hope people find this informing and enjoy setting up arch.