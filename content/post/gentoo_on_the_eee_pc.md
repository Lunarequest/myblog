---
title: "Gentoo Linux on the eee pc"
date: 2022-02-14T19:28:22+05:30
tags: [gentoo, linux, eee-pc]
draft: true
---

I installed gentoo.... am I proud, ehh kinda. After getting used to arch the gentoo install feels very much well not cool. Okay I'm lying it felt very err "hackerseq" choosing use flags and stuff to install gentoo. It was some what easy expect I was stuck in compile hell. 

I decied to install gento on a eee pc a old school netbook(note these are really tiny and kinda cute looking) that like its cousins is small. I can comfortably hold it in single hand. This all comes at a cost. Its 32 bit. For the non-techie any computer after around 2010 it will run in 64-bit mode. This refers to instructions and really all you need to know is that the world is moving away from 32bit as a result only a handful of distros support it.

Gentoo is one of them, its a special distro even among all distro. Most linux distros precompile and package most software. Gentoo makes you compile everything, however there is a sane reason for doing this. You can make your system reach peak performance which is very important when dealing with a Atom Cpu(bassically a raspberry pi 4 can run circles around it).

My ordeal of gentoo started in a fairly straigh forward way. Downloading the iso configuring portage through the make.conf etc but then i hit my first road block see in my naievity I had over estimated the systems age and gone with i386 instead of i686. i686 is the bare minimum to run upstream rust, i585 can run it but requires some things to be disabled.

Thus I entered compile hell and rebuilt the enteir systemd. At this point i had been installing the system for 3 days