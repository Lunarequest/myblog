---
title: "Nixops the future of deploying applications?"
date: 2022-02-20T16:23:10+05:30
tags: ["nixos", "nixops"]
draft: true
---
After my last post I migrated the blog over to nixos, Over the past few weeks I discovered nixops a teraform like tool for orchestrating and managing vms, google cloud platforms, aws container, preconfigured nixos systems, and a large list of other vps providers. Nixops allows you to define and manage your infrastructure in nix, in function it is quite similar to [terraform](https://www.terraform.io/) which allows you to define your infrastructure in HasiCorp lang.

Nixops is very unique in that rather then defining a series of actions which are not determenistic(in other words will not be the same if you reapte then enough), it defines a state the target machine should be, nix the package manager of nixos the computes what changes should occur to the currently running system to reach the state that is required. 

So why is nixops "the future of deploying applications"? It comes down to 1 factor. Everything written in nix is deterministic, being able to define once and deploy a hundered times is the dream of large corps and single man dev teams alike. One of the most common complaints you'll here when working with others is "but it works on my machine" and thats true, it probably does but every system is unique, something as simple as a library being compiled without a feature can break everything.

Nix takes the diffrence out of the equation it can ensure 2 install of nix are exactly the same down to even configuration of software. 