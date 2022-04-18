---
title: "Nixops to Deploy-rs"
date: 2022-04-18T17:07:02+05:30
tags: [nixops, deploy-rs, nixos]
draft: false
---
You probably read my post about `nixops` a tool to remotly manage and provoision NixOs installs. Nixops has 2 distinict versions you can install, `nixops` and `nixopsUnstable`. Unstable as of writing is more or less nixops 2.0. It supports nix flakes, python 3 instead of 2, and a host of features including a plugin system. However migrating from nixops 1 to 2 is completely undocumented. My attempts to switch have failed miserably due to this very issue.

## Enter deploy-rs

Deploy-rs was created by [serkoll](https://serokell.io/) it does a lot of the main use cases of nixops but its written in rust, has a ton of cool features like "magic rollbacks" and the core of deploy-rs profiles. While deploy-rs is fairly limited compared to nixops(nixops supports provisioning AWS machines, vms etc deploy-rs just handles existing nixos installs) what deploy-rs does, it does well.

### Magic rollback

If one had to surmise this feature in a nutshell it would be "A feature that should have been in nixops from day one". The deploy process works a bit like this. First the env we will be deploying is built. After it is built we copy this over to the release machine and finally after this we switch to the new env. However sometimes for various reason when with switch to the new env stuff fails. services crash. If this was nixops we would just leave it in this state.

But this is deploy-rs. Deploy-rs reverse all the changes done and returns the system to the previous known good generation. Magic rollback is a killer feature, you no longer have to worry about your services going offline because of a bad config. 

### Migrating?

Migrating from nixops to deploy-rs is fairly easy, deploy-rs oversimplifying a wrapper around nixos configurations making it super simple to migrate. However deploy-rs does not do secretes, If you need secrets for your configs you need to use a 3rd party tool like sopsnix or agenix. Personally I found sopsnix to be more user friendly but it comes down to what fits your needs better.


Overall I feel until `nixopsUnstable` becomes stable deploy-rs is probably going to be most of the communities go to remote provisioning tool. I will be keenly watching Nixops 2.0 and hoping that if/when it comes out, it will address the scarcity in documentation and fairly high barrier of entry.