---
title: "Nixops the future of deploying applications?"
date: 2022-02-20T16:23:10+05:30
tags: ["nixos", "nixops"]
draft: false
---
After my last post I migrated the blog over to nixos, Over the past few weeks I discovered nixops a terraform like tool for orchestrating and managing vms, google cloud platforms, aws container, preconfigured nixos systems, and a large list of other vps providers. Nixops allows you to define and manage your infrastructure in nix, in function it is quite similar to [terraform](https://www.terraform.io/) which allows you to define your infrastructure in HasiCorp lang.

Nixops is very unique in that rather then defining a series of actions which are not deterministic(in other words will not be the same if you reapte then enough), it defines a state the target machine should be, nix the package manager of nixos the computes what changes should occur to the currently running system to reach the state that is required. 

So why is nixops "the future of deploying applications"? It comes down to 1 factor. Everything written in nix is deterministic, being able to define once and deploy a hundered times is the dream of large corps and single man dev teams alike. One of the most common complaints you'll here when working with others is "but it works on my machine" and thats true, it probably does but every system is unique, something as simple as a library being compiled without a feature can break everything.

Nix takes the diffrence out of the equation it can ensure 2 install of nix are exactly the same down to even configuration of software and service startup order. One of the bigger issues server admins face is that Docker/OCI containers are not reproducible and often simply stop working due to issues with the image. Nix solves these issues elegantly, if you wish to read about this more I recommend this [blog post](https://thewagner.net/blog/2021/02/25/building-container-images-with-nix/) by David Wagner about this.

So whats the catch with nix/nixops? Its poorly documented, you'll often find users using undocumented features or documentation scratching the bare minimum of using a tool. I've found  that Xe Iaso's [blog](https://christine.website/blog) to often document issues, solutions and applications better then the official documentation. While work is being done towards better documenting nix, unfortunately all most all nix documentation requires a understanding of Nix Lang which isn't exactly conventional.

However things are getting better, work is being done improving documentation and bug's are fixed at a high rate. With that said until we do have better documentation for most developers starting with [nix pills)(https://nixos.org/guides/nix-pills/index.html) is the best way to learn nix. From there most documentation makes sense. If you don't get how something works don't hesitate to ask in the official matrix.

-- nullrequest signing off
