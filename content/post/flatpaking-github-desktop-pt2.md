---
title: "Flatpaking Github Desktop Pt2: GPG"
date: 2021-09-30T11:29:44+05:30
tags: [flatpak, github-desktop]
draft: true
---

Hello, hello, hello. This post is going to continue on what I went through maintaining github desktop and ensuring everything works. This will mainly focus on GnuPG since that was where majority of my work focused on.

## What is GnuPG?

GnuPG often refereed to as gpg is the GNU foundations open source implementation of the OpenPGP standard. It is used for cartographical signing and encryption, git uses gpg to signing commits to allow one to verify who made a commit.

After I published the flatpak github user [tommytran732](https://github.com/tommytran732) brought it to my attention that GPG did not work. Initially I thought this would be an easy fix, simply adding `gpg` to should have been enough in my mind. Oh how I was wrong. I ran into multiple issues with gpg running into ioctl errors. 

ioctl errors if you have run into them before are really cryptic, I ended up adding some permissions to the flatpak  `--filesysystem=~/.gnupg:ro`. This would create fix the issue when running gpg from a command line but it wouldn't work if run from `git`. At this point I reached out the the flatpak matrix looking for advice. I was given a link to the Gnome mail flatpak.

Gnome mail used gpg for some functionality and hence used it in the flatpak, I attempted model the flatapk around it using `gpg-agent` and `pinentry` in the flatpak to interact with the host, at this poin I didn't know about the issues I would face using this model. Right away one of the issues that stood out, was if the key had a password it would not work. 

For many weeks I pondered on the solution, until one day while being utterly confused about it in the flatpak matrix(I highly encourage anyone facing issues flatpaking an app to as on the matrix), tommytran732 pointed out that adding `--filesystem=xdg-run/gnupg` and dropping pinentry from the flatpak fixed the issues. So that's what I did. Today if you use the flatpak you'll have the lts version of gpg packaged with Github desktop. 

If by any chance you use a [Yubikey](https://www.yubico.com/) for 2FA with GPG, it won't work. Why ¯\_(ツ)_/¯. I've gotten myself a Yubikey(Thank you Tommy for the kind donation!) and hopefully once I figure out how to set it up I can get to work trying to figure out why it won't work. There will probably be a part 3 once I fix 2FA with GPG.

-- signing off

Nullrequest