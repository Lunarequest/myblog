---
title: "Flatpaking Github Desktop Pt2: GPG"
date: 2021-09-30T11:29:44+05:30
tags: [flatpak, github-desktop]
draft: true
---

Hello, hello, hello. This post is going to continue on what I went through maintaining github desktop and ensuring everything works. This will mainly focus on GnuPG since that was where majority of my work focused on.

## What is GnuPG?

GnuPG often refereed to as GPG is the GNU foundations open source implementation of the OpenPGP standard. It is used for cartographical signing and encryption, git uses GPG to signing commits to allow one to verify who made a commit.

After I published the flatpak github user [tommytran732](https://github.com/tommytran732) brought it to my attention that GPG did not work. Initially I thought this would be an easy fix, simply adding GPG to the flatpak should have been enough in my mind. Oh how I was wrong. I ran into multiple issues with gpg spitting out ioctl errors. 

ioctl errors, if you have run into them before, are really cryptic. I ended up adding some permissions to the flatpak:  `--filesysystem=~/.gnupg:ro`. This would create a fix for the issue when running gpg from a command line but it wouldn't work if run from `git`. At this point running out of ideas, I reached out the the flatpak matrix looking for advice. I was given a link to the Gnome Mail flatpak.

Gnome Mail used GPG for some functionality and hence used it in the flatpak, I attempted to model the flatapk around it using `gpg-agent` and `pinentry` in the flatpak to interact with the host, at this point I didn't know about the issues I would face using this model. Right away one of the issues that stood out was if the key had a password it would not work. 

For many weeks I pondered on the solution, until one day while being utterly confused about it in the flatpak matrix (I highly encourage anyone facing issues flatpaking an app to ask for help on the flatpak matrix). Github user tommytran732 pointed out that adding `--filesystem=xdg-run/gnupg:ro` and dropping pinentry from the flatpak fixed the issues.

Breaking down the fix, this permission allows gpg to interact with the hosts `gpg-agent` daemon/instance. When the daemon receives a request for the GPG key registered for git commit signing, if the key is already unlocked it just hands over the required data. If the key is not unlocked it will use `pinentry` to unlock it for you.

If by any chance you use a [Yubikey](https://www.yubico.com/) for 2FA with GPG, it won't work. Why? ¯\\\_(ツ)_/¯. I've gotten myself a Yubikey (Thank you Tommy for the kind donation!) and hopefully once I figure out how to set it up I can get to work trying to figure out why it won't work. There will probably be a part 3 once I fix 2FA with GPG.

-- signing off

Nullrequest
