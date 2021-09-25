---
title: "My Adventure Flatpaking Github Desktop Pt1"
date: 2021-09-25T18:56:09+05:30
tags: [flatpak, github-desktop]
draft: true
---

Its been a while since I've last posted but I have returned with the story of my work on the github desktop flatpak. If you haven't figured out by the title this is going to be a 2 parter. The first part(what you're reading now) is going to be up to submitting the flatpak to [flathub](https://flathub.org). The second part will be about fixing issues after getting on flathub. 

Well lets start with what a "flatpak" is. A flatpak is a linux distribution agnostic package format. It works on almost any linux distribution with little to work beyond building or installing it. In may this year I gave a friend of mine a open offer, name one app and I'll flatpak it. This was just after I had created a flatpak for GitAhead another git manager similar to Github Desktop.

Naively I thought it shouldn't be hard to package it, after all I've had experience turning another git manager into a flatpak. I was wrong, very very wrong. When I started the first thing I did was check if someone else was working on a flatpak, if you are planing on flatpaking an app make sure no one else is doing it as well, if someone else is you should consider contributing to the effort 

in late 2020 [Damián Nohales](https://github.com/dnohales) had attempted to do this but failed due to issues with electron interacting with the flatpak sandbox. I myself knew about these issues from working on another flatpak. The issue stems from electrons flatpak being a suid(Set Uid) binary that can become root on start. Flatpak blocks this due to security issues. There are 2 ways to fix this. The first one is to launch the application with the flag `--nosandbox` which impacts the security of the application and in some cases can break them

The other smarter method is [zypak](https://github.com/refi64/zypak) a reimplementation of the chromium/electron sandbox that doesn't require disabling the sandbox. Using this knowledge I was able to modify Damián's attempt at a flatpak to attempt to get it to run. I was able to update to the latest release. Right away a new issue cropped up, I couldn't login into github desktop. I wasn't able to fix this issue until recently.

it wasn't until june where i started working on this again. I attempted to bump to the latest release things broke hard, first I needed to update the node version. Damián had used node 10 which now was incompatible. I ended up going with node 14 instead. After a day of getting thing working again I had hit a new issue. At some point a new dependency was added. 

`node-detect-arm64-translation` this one dependency stumped me for weeks. Eventually I asked Brendan Forster the maintainer of the linux fork of Github desktop what it did and if I could "patch it out". After getting the okay, I wrote a patch removing it completely. It was ugly but did its job allowing me to continue. The yarn generator was later update to actually setup the repo as a tarball that yarn could use directly allowing me to drop all patches.

Finally that left me with one issue. The login didn't work, I didn't know why and had no idea how to debug it. Eventually I ask the flatpak matrix for ideas. It turns out the solution was adding `%U` to the desktop file's  `exec` felid. `%U` tells you desktop environment that the executable takes args and where positionally to add them.

Finally with the major blocker out of the way. I began adding flatpak specific functionality, support for spawning programs outside the sandbox, fixing issues with trashing files(this technically isn't fixed but the issue is on the portal side not mine). After this I managed to get it on flathub, but that was not the end of my woes with github desktop but that's a post for another time.

-- signing off

Nullrequest