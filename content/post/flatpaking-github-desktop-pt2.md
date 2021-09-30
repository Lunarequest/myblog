---
title: "Flatpaking Github Desktop Pt2: GPG"
date: 2021-09-30T11:29:44+05:30
tags: [flatpak, github-desktop]
draft: true
---

Hello, hello, hello. This post is going to continue on what I went through maintaing github desktop and ensuring everything works. This will mainly focus on GnuPG since that was where majoirty of my work focused on.

## What is GnuPG?

GnuPG often refered to as gpg is the GNU foundations open source implmentation of the OpenPGP standard. It is used for cryptographical signing and encryption, git uses gpg to signing commits to allow one to verify who made a commit.

After I published the flatpak github user [tommytran732](https://github.com/tommytran732) brought it to my attention 