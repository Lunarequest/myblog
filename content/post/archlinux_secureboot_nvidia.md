---
title: "Archlinux with secureboot on a nvidia machine"
date: 2022-03-26T19:12:17+05:30
tags: ['arch', 'linux','secureboot', 'nvidia']
draft: true
---

Many moons ago when I first started using archlinux with secure boot, I always dreamed of running it on my desktop a machine with a Nvidia graphics card. While for the most part the desktop has been great and leagues faster then my laptop, secure boot never worked with it. Enabling secureboot would result in a black screen with no output forcing me every time to reset the CMOS.

For a while I tried solving the problem, asking on reddit and even reaching out to my motherboard and graphics card manufacturers who pointed the blame at each other but today I made a break through. I figured out why it was happening and am happy to say, I am running archlinux with secureboot using EFISTUBS with a Nvidia graphics card

To start with we need to shame me a little...I misinterpreted some stuff hard and bassically goofed up. So Nvidia being the annoying people they are require your signature DB to contain mircosofts secureboot keys, (these can be grabed [here](https://www.microsoft.com/pkiops/certs/MicWinProPCA2011_2011-10-19.crt) & [here](https://www.microsoft.com/pkiops/certs/MicCorUEFCA2011_2011-06-27.crt)). The arch wiki has a [section](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Microsoft_Windows) on how to use them. 

By keeping these around and adding your key everything just works. On some graphics cards its possible to mod the card's bios to not require this but I would not recomend this. Overall its pretty much a bog standard secure boot setup. In tandum to this I use EFISTUBs this allows Firmware to load the kernel like it was any old efi stub. I use systemd instead of direct to the firmware since I prefer having the ability to choose kernels without dropping into the firmware.

The only differnce when using EFISTUBS I have found is that a custom hook needs to be used, I used this one based on a hook used to automatically sign kernels with MOKUTIL.

```bash
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux
Target = linux-hardened

[Action]
Description = Signing kernel with Db Key for Secure Boot
When = PostTransaction
Exec = /usr/bin/find /boot/EFI/Linux -maxdepth 1 -name 'archlinux-*' -exec /usr/bin/sh -c 'if ! /usr/bin/sbverify --list {} 2>/dev/null | /usr/bin/grep -q "signature certificates"; then /usr/bin/sbsign --key /etc/secureboot/DB.key --cert /etc/secureboot/DB.crt --output {} {}; fi' ;
Depends = sbsigntools
Depends = findutils
Depends = grep
```
You can feel free to modify and use this to your needs. As for genrating EFISTUBs, this [blog post](https://linderud.dev/blog/mkinitcpio-v31-and-uefi-stubs/) by Morten Linderud aka foxboron explains how to get started pretty well. If you find this post trying to hunt for a solution for the problem like me I hope it serves you well.

— This is nullrquest signing off