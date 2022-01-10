---
title: "Installing nixos on a running install of Arch Linux"
date: 2022-01-10T08:28:12+05:30
tags: ["nixos", "how did we get here"]
draft: true
---

the website you are reading this on used to run arch linux. I spent a lot of time automating reinstallations, only to discover. Arch is really really stable. I never had to reinstall. However, I had to reboot a lot. My uptime would probably be 1 to 2 weeks since without rebooting and allowing all services to restart preformance would be heavily degreaded. 


![screenshot of neofetch on my server](/images/arch.png)

Well why would I replace arch with nixos? Nixos uses the nix package manager which handles packages in a declerative manner. Everything from what packages to be installed to the configueration of something like nginx is done from the configueration file for nix. This means that every config is 100% reproducible and simply by copying the config you can replicate the setup. I do intened to at some point replace it with a collection of raspberry PIs, hence being able to migrate easliy is very easy.

I haven't done something like this before, if I being honest. Replacing a runing distro while its running sounds very much like something we'd spend hours saying **DO NOT DO**. Yet everyone from debian to arch has a guide on how to do this, granted most of them use a smaller partion on the drive. Nixos is slightly diffrent. It has an option called `NIXOS_LUSTRATE` tells this is the target disk. replace everything on it. While this is going to be a bit of the beaten track, I'm hoping I figure out how this works so I can reinstall my rocky linux system.

This isn't going to be like most posts, I'm going to bassically explain what I'm currently doing/screwing up and hopefully at the end this arch box is running Nixos and I can drop my really janky nginx configs. I mean there really isn't another choice....

## First Attempt

To start with I need to get `nix` on arch. Thankfully its as easy as running `curl -L https://nixos.org/nix/install | sh`. The script makes a `/nix/` folder for its "store" and nicely sits next to the current package manager. When nix is installed by this method it uses a generic package repo that has no testing, we need to switch this to the nixos-verion repo(replace version with the version of nixos you want to install).

To switch channels you need to use the nix-channel command. Its again fairly simple `nix-channel --add https://nixos.org/channels/nixos-21.11 nixpkgs`, replace 21.11 with any release you would prefer. Now we need the nixos-install tools, this includes `nixos-genreate-config` & `nixos-install`. For good mesure before this run `nix-channel --update`. After this we can use `nix-env` install our deps. While this isn't "ideal" on a normal install we are replacing an os its okay!

I am doing a bit of a copout here. I really can't risk the lustrate stuff so instead I will be first using a usb drive to install nixos too before I install to the internal driver. Will it work, probably. is it easier... I don't know to be honest.

To start the proccess I mounted my usb drives partions at `/mnt/`(the future root) and `/mnt/boot`, after this using ```sudo `which nixos-generate-config' --root /mnt```. After making a super minmal config and we are off to the races....or not. The docs on installing nixos from a running system tell you to run this command ```sudo PATH="$PATH" NIX_PATH="$NIX_PATH" `which nixos-install` --root /mnt```. except `$NIX_PATH` was not defined...

After about 10 minutes of googling and realising the same var was defined on my laptop(which is runing nixos). I figured out the env var should be `nixpkgs=/nix/var/nix/profiles/per-user/$USER/channels/nixos` which now made me run into problem 2.... I ran out of space on the boot drive.

## Attempt 2

Here we go again. After reparitioning giving the boot volume more space I did the steps for the configureation again. I made a superslim config and reran  ```sudo PATH="$PATH" NIX_PATH="$NIX_PATH" `which nixos-install` --root /mnt``` hoping this time it would, work and it didn't....why? the bios refused to accept it as a bootable media...

## Attempt 3
time for round 3, this time I give up on the regular method. I'm going to use lustrate. If it doesn't work I'm going to just use a iso and install it. To Lustrate a distro according to the nix manual means to completely replace the running distro with another one. This process is how people run Nix on digital ocean. Its fairly straight forward process that is also very easy to screw up........ The process starts with genrating configs, and writing them however you should set your intial root password to nothing using this line in your config.

```nix
users.users.root.initialHashedPassword = "";
```

After this we build a current system. Using `sudo NIX_PATH="$NIX_PATH"  nix-env -p /nix/var/nix/profiles/system -f '<nixpkgs/nixos>' -I nixos-config=/etc/nixos/configuration.nix -iA system`. From here we need to finlize the system. First we create a file `/etc/NIXOS`, this tells the nixos bootup script this is a nixos installed parition. Next `/etc/NIXOS_LUSTRATE` tells the NixOS bootup scripts to move everything that's in the root partition to /old-root. This will move your existing distribution out of the way in the very early stages of the NixOS bootup.

You'll want to use `echo etc/nixos | sudo tee -a /etc/NIXOS_LUSTRATE`  to tell them not to remove the configureations. From here we use the switch-to-config script to automagically update our boot parition after moving the files in the boot parition `sudo mv -v /boot/* /boot.bak && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot`. After this we reboot and hope everything worked...................YES YES it worked. This is where this post ends. I'm going to configure some stuff from here and get my website back up.

-- nullrequest