---
title: "Installing NixOS on a Running Install of Arch Linux"
date: 2022-01-10T08:28:12+05:30
tags: ["nixos", "how did we get here"]
draft: false
---

The website you are reading this on used to run arch Linux. I spent a lot of time automating reinstallations, only to discover. Arch is really stable. I never had to reinstall. However, I had to reboot a lot. My uptime would probably be 1 to 2 weeks since without rebooting and allowing all services to restart performance would be heavily degraded. 

![screenshot of neofetch on my server](/images/arch.png)

Well, why would I replace arch with Nixos? Nixos uses the nix package manager which handles packages in a declarative manner. Everything from what packages are to be installed to the configuration of something like Nginx is done through the configuration.nix file. This means that every config is 100% reproducible and simply by copying the config you can replicate the setup. I do intend to at some point replace it with a collection of Raspberry Pis, by using nix migrating is made simpler.

I haven't done something like this before. Replacing a running distro while it's running sounds very much like something we'd spend hours saying **DO NOT DO**. Yet everyone from Debian to Arch Linux has a guide on how to do this, granted most of them use a smaller partition on the drive. Nixos is slightly different. It has an option called `NIXOS_LUSTRATE`which tells this nix that is the target disk and to replace everything on it. I'm hoping to avoid doing this, as it seems riskier instead I opted to use a USB drive, installing to it and the booting of it before replacing the arch install.

This isn't going to be like most posts, I'm going to explain what I'm currently doing/screwing up and hopefully, in the end,  this arch box will be running Nixos and I can drop my janky Nginx configs. I mean there isn't another choice once I start...

## First Attempt

To start with I need to get `nix` on Arch Linux. Thankfully it is as easy as running `curl -L https://nixos.org/nix/install | sh`. The script makes a `/nix/` folder for its "store" and nicely sits next to the current package manager. When nix is installed by this method it uses a generic package repo that has no testing, we need to switch this to the nixos-version repo(replace version with the version of nixos you want to install).

To switch channels you need to use the nix-channel command. It is again fairly simple `nix-channel --add https://nixos.org/channels/nixos-21.11 nixpkgs`, replace 21.11 with any release you would prefer. Now we need the nixos-install tools, this includes `nixos-generate-config` & `nixos-install`. For good measure before this run `nix-channel --update`. After this, I can use `nix-env`  to install the tools required for the job. While this isn't "ideal" on a normal install, this is the only way we can get these tools.

To start the process I mounted my USB drives partitions at `/mnt/`(the future root) and `/mnt/boot`, after this using ```sudo `which nixos-generate-config' --root /mnt```. After making a super minimal config and we are off to the races....or not. The docs on installing nixos from a running system tell you to run this command ```sudo PATH="$PATH" NIX_PATH="$NIX_PATH" `which nixos-install` --root /mnt```. except `$NIX_PATH` was not defined...

After about 10 minutes of googling and realizing the same var was defined on my laptop(which is running nixos). I figured out the env var should be `nixpkgs=/nix/var/nix/profiles/per-user/$USER/channels/nixos` which now made me run into problem 2.... I ran out of space on the boot drive.

## Attempt 2

Here we go again. After repartitioning giving the boot volume more space I did the steps for the configuration again. I made a superslim config and reran  ```sudo PATH="$PATH" NIX_PATH="$NIX_PATH" `which nixos-install` --root /mnt``` hoping this time it would, work and it didn't....why? the bios refused to accept it as bootable media...

## Attempt 3
time for round 3, this time I give up on the regular method. I'm going to use lustrate. If it doesn't work I'm going to just use an iso and install it. To Lustrate a distro according to the nix manual means to completely replace the running distro with another one. This process is how people run NixOS on digital ocean. It is an easy process that is also very easy to screw up........ The process starts with generating configs, and writing them however I set my initial root password to nothing using this line in my config since after we won't get a prompt to change the password

```nix
users.users.root.initialHashedPassword = "";
```

After this, I needed to build my config on top of the current system. Using `sudo NIX_PATH="$NIX_PATH"  nix-env -p /nix/var/nix/profiles/system -f '<nixpkgs/nixos>' -I nixos-config=/etc/nixos/configuration.nix -iA system`. From here I needed to finalize the system. First I needed to create `/etc/NIXOS`, this tells the nixos bootup script this is a nixos installed partition. Next a file at `/etc/NIXOS_LUSTRATE`, which tells the NixOS bootup scripts to move everything that's in the root partition to /old-root. This will move your existing distribution out of the way in the very early stages of the NixOS bootup. Any paths in this file are not moved to old-root.

I needed to use `echo etc/nixos | sudo tee -a /etc/NIXOS_LUSTRATE`  to tell the bootstrap script not to move the configuration to /old-root. From here I use the switch-to-config script to automatically update my boot partition after moving the files in the boot partition `sudo mv -v /boot/* /boot.bak && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot`. After this, we reboot and hope everything worked................... YES! YES, it worked. This is where this post ends. I'm going to configure some Nginx stuff and get the blog back up. cya, folks on the flip side.

![screenshot of neofetch on nix](/images/nixos.png)

-- signing off

Nullrequest
