---
title: "Self hosting"
date: 2020-08-20T15:50:31+05:30
series: [movingtomyserver]
tags: [self_hosting, hugo]
draft: false
---
## Background

Recently I found out that my [friend](https://twitter.com/ayyeve) self hosted her [website](https://ayyeve.xyz/). I was actually pretty surprised this was possible. After finding out this was possible I began working on porting my blog to be run off netfliy and on my own servers. This is going to be my first long term project and series. I will be posting around once a month with updates and changes I will be implementing. 

## The base machine

I currently will be hosting my website off a HP Compaq 8000 Elite. This isn't ideal however as time passes I will be replacing this with more powerful hardware. I plan to use a headless arch linux install as the OS running on it. I am sure a lot of you will be getting ready to hit my comment section going "null arch linux is a rolling distro, its not stable" and my response would be "well yes but no". Why the weird yes but no. Well arch linux lacks a stable release it is actually very stable. 

What many people tend to forget is that arch linux has a testing branch. It would be suicide to use the testing branch on a production server. why? well testing has everything out of the box no fixes, no patches to fix things on arch. The regular repos are actually very stable and may require people to manually fix issues during updates. Which is why exist. 

## The stages

I've broken this move down to three stages. 
1. rework
2. custom tooling
3. deploy

Stage 1 is what I am working on right now. currently a lot of the website relies on netlify to work. like in the contact form. I am working on steady removing netlify from the equation. With this post you will see the biggest change so far. The contact form will no longer use netify. Over time this will extend to the rest of the website. Stage 2 will involve writing scripts to automate everything and stage 3 is testing everything while deploying it. 

I hope you enjoyed this shorter then normal post. I will be back in a few weeks with another post hopefully entering stage 2.

— This is nullrquest signing off   
