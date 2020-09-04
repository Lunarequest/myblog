---
title: "Ultimate arch linux setup"
date: 2020-07-28T15:46:09+05:30
tags: [arch, linux, secureboot, plymouth]
draft: false
---
# Background
Recently after distro-hopping I came back to Arch Linux. It was perfect for me and I really can't move to another distro without missing the AUR. After installing Arch I went through a few extra steps to add some features like secure boot(I know its not needed) and Plymouth to add m to my setup. __I am assuming you have used Linux this does not and will not replace the arch wiki__.

## The arch install. 
This is the most difficult part of arch. I will not be making a guide for it as Arch Linux changes very often and the best source is the Arch wiki. I know its scary but put in the hard work and you will be rewarded with a arch install. 
## Swap-files
swapfiles are like swap partition but rather then use a partition uses a file. Usually this is `/swapfile`. To start with you will need to make a file. If you use btrfs you will need to set some permissions. 
```shell
$ sudo dd if=/dev/zero of=/swapfile bs=1M count=512 status=progress
```
Change count to the size of ram you have if you want to hibernate. Next up we need to remove the read permissions on the file. Its surprisingly easy to change this. `sudo chmod 600 /swapfile` will allow remove the read/write permissions. Next we need to format the file to make it a swap device. This step is very simple.
```shell
$ sudo mkswap /swapfile
```
Next you should activate the swap device like this `sudo swapon /swapfile`. Finally you should edit the fstab file to ensure its activated on boot. You can edit the `/etc/fstab` file with you preferred text editor. Add the following line at the end and when you reboot your system should activate the swap device.
```
/swapfile none swap defaults 0 0
```
## Secure boot
I am using custom keys and have wiped the Microsoft keys of my system for better security. If you want to keep these keys you will need to use preboot/shim. Look into the arch wiki on how to use them.
To start off we need to install `efitools`
```shell
$ sudo pacman -S efitools
```
I acutuly did everything here in a folder I created. The path is `/etc/secure-boot/`. I recomand doing the same. First we create a GUID
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
You will need to do this every time you update the kernel or boot-loader. I used a pacman hook to do this. I also moved all the keys to /etc/secure-boot
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
You should also copy all the keys to the /boot partition.
Next you need to put your firmware into setup mode and enroll the keys. You can follow this guide on how to enroll the keys www.rodsbooks.com/efi-bootloaders/controlling-sb.html#setuputil.

## Plymouth
Fist we need to install a aur helper. I prefer yay but you can use any helper or manually git clone and `makepkg` each package on your own.

```shell
$ git clone https://aur.archlinux.org/yay.git
```
These packages are a must if you want to install any aur package.
```shell
$ sudo pacman -S base-devel
```
Next to build and install yay. run these commands
```shell
$ makepkg -si
```
After this we can install Plymouth.
```shell
$ yay plymouth
```
You can install the git or stable version. Next you need to edit the `/etc/mkinitcpio.conf`.
```shell
$ sudo nano /etc/mkinitcpio.conf 
```
you need to add the plymouth hook to the HOOKS section `HOOKS=(base udev plymouth ...)`. You might also need to add your drivers kernel module. 

At this point its time to get a theme for the plymouth screen. I used this [theme](https://aur.archlinux.org/packages/plymouth-theme-darth-vader-git/). However you can use the one you prefer.

You can get a list of choices using the following command
```shell
$ plymouth-set-default-theme -l
```
Finally to set the theme run 
```shell 
$ sudo plymouth-set-default-theme -R theme
```
Add this to the options line in the arch.conf in the /boot partition. `quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0`
After this you can reboot the system and you should have your theme shown when you boot up.

## Hibernation
Hibernation is a ~~useful~~ requirement on laptops. When a laptop enters hibernation it saves the contents of ram to the hdd/sdd saving power but speeding up boot time. On arch linux you need to add kernel hooks and parameters to tell the system on how to resume. To start off we can add the nitpicking hook. You should open the `/etc/mkinitcpio.conf` file in a text editor and updated the hooks.

```conf
HOOKS=(base udev plymouth autodetect modconf block filesystems resume keyboard fsck)
```
The hooks should look like this now. Next we need to add a kernel parameter so the kernel knows where to resume from. However before this we need to find the "offset" of the swapfile. To do this we can use `filefrag`.
```shell
Filesystem type is: ef53
File size of /swapfile is 8388608000 (2048000 blocks of 4096 bytes)
ext: logical_offset: physical_offset: length: expected: flags:
0: 0.. 6143: 321536.. 327679: 6144: 
1: 6144.. 12287: 403456.. 409599: 6144: 327680:
2: 12288.. 14335: 466944.. 468991: 2048: 409600:
3: 14336.. 16383: 522240.. 524287: 2048: 468992:
4: 16384.. 47103: 559104.. 589823: 30720: 524288:
5: 47104.. 49151: 673792.. 675839: 2048: 589824:
6: 49152.. 59391: 677888.. 688127: 10240: 675840:
7: 59392.. 83967: 696320.. 720895: 24576: 688128:
8: 83968.. 86015: 735232.. 737279: 2048: 720896:
```
You should look for the first physical_offset value. In my case it was 321536. Now we are ready to add our kernel parameters. There are 2 parameters we need to add the `resume` parameter and the `resume_offset` parameter. For the resume parameter you need to use the UUID of the partion the swapfile is on. your parameter should look like this.`resume=UUID=19a7a7b7-04d9-4abc-b1bf-8d53ea7de04e resume_offset=321536`
## Final thoughts
I know it was a bit long but I spent a long time fixing issues and getting things working. I really enjoy arch and I hope people find this informing and enjoy setting up arch.

— This is nullrquest signing off 