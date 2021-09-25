---
title: "Porting Coreboot to support my laptop"
date: 2020-10-01T16:05:59+05:30
tags: [coreboot]
draft: true
---
Over the past few months I have found out and become interested in a BIOS/UEFI implementation. Well coreboot technically is a hardware init software and it has "payloads" that can be used to extend its functionality to add features like UEFI/BIOS loaders. Coreboot is actually more main stream then most people realise. If you use a chromebook chances are it use coreboot with ether U-Boot or depthcharge a custom payload developed by Google(technically its open source and you can, with work use it on any system). One of the benefits of coreboot is it boot speed which is why google uses it on their chromebooks.

The entire hardware init process under coreboot takes 0.5S!!! Coreboot does this by doing things diffidently. I hope more companies look into moving to coreboot as it is truly a level above other implementations. My laptop a inspiron 3420 is sadly unsupported by coreboot. However coreboot is luckily fairly easy to port to the sandy bridge era of cpus. This will be a me writing on a non fixed shecdual about how things are going how are things and ultimatly a refrence in case someone wants to pick up where I left of if the project in the end fails.

## Budget

One of the biggest costaints I need to take into consideration is my budget.This means no raspberry PIs. No fancy logic analyzers. No chip whispers unless I can borrow one which currently I can not. To reduce the issue I have found some alterntives one can use instread.

1. PL2303 - PL2303HX USB to TTL
2. FT2232H Mini Module
3. CH341A EEPROM flash bios programmer

These are lowish cost stuff that you can use to work on coreboot. The first 2 allow you to debug issues with coreboot without spending alot of money on a logic analyzer. The last one allows you to replace the Raspbery pi with any machine. The raspbrrey pi is usually used to flash and dump the bin of the BIOS chip. This allows me to replace expensive tech with cheap components you buy online for a fraction of the cost.

I'll write back when I figure out some more intersting things and maybe have a working coreboot setup