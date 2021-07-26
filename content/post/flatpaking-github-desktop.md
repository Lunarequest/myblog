---
title: "My Adventure Flatpaking Github Desktop"
date: 2021-07-19T18:56:09+05:30
tags: [flatpak, github-desktop]
draft: true
---

Flatpak is a linux distribution agnostic package format. It works on almost any linux distribution with little to work beyond building it. In may this year I gave a friend of mine a open offer, name one app and I'll flatpak it. This was just after I had created a flatpak for GitAhead another git manager similar to Github Desktop.

Naively I thought it shouldn't be hard to package it, after all I've had experience turning another git manager into a flatpak. I was wrong, very very wrong. When I started the first thing I did was check if someone else was working on a flatpak, if you are planing on flatpaking an app make sure no one else is doing it as well, if someone else is you should consider contributing to the effort 

in late 2020 Damián Nohales had attempted to do this but failed due to issues the underlying flatpak. I myself knew about these issues from working on another flatpak. The issue stems from electrons flatpak being a suid(Set Uid) binary that can become root on start. Flatpak blocks this due to security issues. There are 2 ways to fix this. The first one is to launch the application with the flag `--nosandbox` which tends to impact the security of the application.

The other smarter method is zypak a reimplementation of the chromium/electron sandbox that doesn't require disabling the sandbox. Using this knowledge I was able to modify Damián Nohales attempt at a flatpak to attempt to get it to run. I was able to update to the latest release. Right away a new issue cropped up, I couldn't login into github desktop. I wasn't able to fix this issue until recently.

it wasn't until june where i started working on this again. I attempted to bump to the latest release things broke hard, first I needed to update the node version. Damián had used node 10 which now was incompatible. I ended up going with node 14 instead. After a day of getting thing working again I had hit a new issue. At some point a new dependency was added. 

`node-detect-arm64-translation` this one dependency stumped me for weeks. Eventually I asked Brendan Forster the maintainer of the linux fork of Github desktop what it did and if I could "patch it out". After getting the okay, I wrote a patch removing it completely. It was ugly but did its job allowing me to continue.

The issue with logins, it turns out `%U` being omitted from a desktop file can ruin everything. A desktop file is in simple terms how a linux distro knows information such as what icon an app uses, the executable it uses etc. `%U` tells the os when someone launches this with the desktop file pass the arguments to the executable. Adding this fixed a lot of issues.

Eventually I had to start adding flatpak specific behaviour, Brendan was awesome and helped me take a lot of the patches required to run upstream reducing the development burden that I faced. Maintaining patch sets is a lot of work even a simple 5 line change can become difficult with every update. 

Currently there are 4 patches, 1 has already been upstreamed another will be soon. The other 2 are minor patches which should be fairly easy to maintain. With help from upstream maintaining this flatpak should be fairly easy.