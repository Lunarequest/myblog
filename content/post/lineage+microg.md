---
title: "Lineage OS + MicroG = ❤️?"
date: 2022-09-11T10:37:28+05:30
tags: []
draft: true
---

[Lineage OS](https://lineageos.org) is one of the older roms in the scene, it is one of the most well known roms choosing a minimalistic design that focuses on utility and function. By default Lineage doesn't come with any google apps let alone a app store. Normally one needs to download a Google apps(Gapps) add on like OpenGapps or MindTheGapps. [MicroG](https://microg.org) takes a different approach. Instead of simply packaging Gapps in a flashable zip, MicroG reimplements Gapps as opensource userspace binaries & libraries. In this post I'm going to deep dive into MicroG VS Gapps and how it works with Lineage os.

## Deep Dive into MicroG

To start with we need to understand the difference between Userspace/Userland vs System Space/System Land. It's easier to visualise everything then to read a wall of text explaining everything.

```goat
        .-------------------------------.
        |userland where you normaly are |
        .--------------.----------------.
                       |
                       .
                      / \
                     /   \
                    /     \ 
                   /       \
                  /         \
                 /           \ 
                /             \
      .--------.--.   .--------.---------------.
      |Binder IPC |   |Android System Services |
      .-----.-----.   .---------.--------------.
             \                 /
              \               / 
               \             /
                \           /
           .-----.---------.----------.
           |Hardware Abstraction Layer|
           .-----------.--------------.
                       |
               .-------.--------.
               |The linux kernel|
               .----------------.
```
From a high level view this is pretty much how a normal android system looks. Due to Linux's Inherent serperation between privilleged users(i.e. root) and unprivilaged users(you) programs running as Andoird System Services have privillages closer to a root user. These are kept in check by selinux. However, many of googles services such as the Playstore, Safetynet and many others are system apps.

This means effectivly you can not do the following under normal conditions(keep in mind normal, we'll come back to this soon)
- Kill Safetynet
- uninstall these apps(many vendors ship blotware and prevent you from unistalling through this method)
- DeGoolge you current rom.
- modify or change these apps
However a lot changes if you can get root. One of the simplest and well known ways is magisk(I'm not going into detail since it's not important). As root you could do a lot of the above safely except, remove Gapps. Gapps actually repalce core components of the system making it very very hard to revert these changes. Google uses these privilleges to ensure a rom is not modified and ensure security of the system from thier persepective.

MicroG on the other hand takes a diffrent approch, rather then run these binaries as privilleged process MicroG reimplmented these api's as userland privilleged binaries. Infact you can install these as you would any old APK without any issue. However for the simplest installation experince it is recomended to use the magisk MicroG installer. 

This differnce in privillege means that we can be more certain about what these binaries are doing in the background, and to some degree nuter their powers.

## Lineage OS

Lineage OS is one of the oldest roms, it was created when Cyanogen mod(CM) shutdown in 2016. Lineage OS has a very simplistic design by default utilizing almost everything from ASOP, only shiping a few unique features. Due to its simplicity and ability to be extended Lineage has become very popluar and often is used as a base for roms.

