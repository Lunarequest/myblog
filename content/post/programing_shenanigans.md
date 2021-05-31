---
title: "the wacky world of programming. shenanigans that probably happened in your life time"
date: 2021-03-18T12:22:27+05:30
tags: [shenanigans]
draft: false
---
The world of programming is no stranger to feuds, after all we are all just human. Often times big events that broke parts of the internet often go unnoticed by the wider public. In this article I'm going to give you some insight into the wacky would of progammers everything from how a spat between a company and a small programmer almost broke the internet to how to power houses of the linux world clashed.

## Leftpad, The story of how 11 lines of codes broke the Internet

The story of leftpad starts on Mar 14, 2014. Github user [azer](https://github.com/azer) created leftpad a javascript package that "pads" a string to the left. For many years leftpad slowly grew in size handling more edge cases, getting added to big projects like bable. The end result was a massive tower of Jenga with leftpad holding up a corner. One day kik the instant messaging company came after azer for creating a npm package named kik. 

Kik sent him a email, asking azer to "unpublish" his module kik on npm which anyone would answer "no". Kik replied with sending him the following "I don’t wanna be dick about it, but “kik” is our registered brand and our lawyers gonna be banging on your door, and taking down your accounts". 

After this Azer just stopped replying to very unprofessional emails they sent him. Eventually they jumped over his head and asked npm to remove his module. Azer wasn't happy(would anyone in his position be?). Azer no longer felt safe publishing his modules and work to NPM and decided to remove all his work on it.

The fall out culminated on march 22, every single one of his modules where unpublished including leftpad. Thousands of package including Bable just stopped working. People were shocked and confused, no one  could explain why some many things just broke. Reddit threads, github issue and panicked email chains tracked down the issue, leftpad had "disappeared". 

People eventually tracked down the issue and created this [github issue](https://github.com/left-pad/left-pad/issues/4). Leftpad was removed from many projects but this raises the question, why did so many projects use a package with only 11 lines of code? Well there are a lot of explanations for this. If you want to read about some I suggest this [article](https://www.davidhaney.io/npm-left-pad-have-we-forgotten-how-to-program/) or if you want to read the emails kik and azer exchanged you can read this [medium post](https://medium.com/@mproberts/a-discussion-about-the-breaking-of-the-internet-3d4d2a83aa4d#.ld8o5zqz7).

## Mageia vs OpenMandriva



 
