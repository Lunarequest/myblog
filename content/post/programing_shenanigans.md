---
title: "The wacky world of programming. Shenanigans that probably happened in your life time"
date: 2021-03-18T12:22:27+05:30
tags: [shenanigans]
draft: true
---
The world of programming is no stranger to feuds, after all we are all just human. Often times big events that broke parts of the internet often go unnoticed by the wider public. In this article I'm going to give you some insight into the wacky would of progammers everything from how a spat between a company and a small programmer almost broke the internet to how to power houses of the linux world clashed.

## Leftpad, The story of how 11 lines of codes broke the Internet

The story of leftpad starts on Mar 14, 2014. Github user [azer](https://github.com/azer) created leftpad a javascript package that "pads" a string to the left. For many years leftpad slowly grew in size handling more edge cases, getting added to big projects like bable. The end result was a massive tower of Jenga with leftpad holding up a corner. One day kik the instant messaging company came after azer for creating a npm package named kik.

Kik sent him a email, asking azer to "unpublish" his module kik on npm which anyone would answer "no". Kik replied with sending him the following "I don’t wanna be dick about it, but “kik” is our registered brand and our lawyers gonna be banging on your door, and taking down your accounts".

After this Azer just stopped replying to very unprofessional emails they sent him. Eventually they jumped over his head and asked npm to remove his module. Azer wasn't happy(would anyone in his position be?). Azer no longer felt safe publishing his modules and work to NPM and decided to remove all his work on it.

The fall out culminated on march 22, every single one of his modules where unpublished including leftpad. Thousands of package including Bable just stopped working. People were shocked and confused, no one  could explain why some many things just broke. Reddit threads, github issue and panicked email chains tracked down the issue, leftpad had "disappeared".

People eventually tracked down the issue and created this [github issue](https://github.com/left-pad/left-pad/issues/4). Leftpad was removed from many projects but this raises the question, why did so many projects use a package with only 11 lines of code? Well there are a lot of explanations for this. If you want to read about some I suggest this [article](https://www.davidhaney.io/npm-left-pad-have-we-forgotten-how-to-program/) or if you want to read the emails kik and azer exchanged you can read this [medium post](https://medium.com/@mproberts/a-discussion-about-the-breaking-of-the-internet-3d4d2a83aa4d#.ld8o5zqz7).

## Andrew Lee and freenode

For the uninfomed freenode is a IRC or internet relay chat network. Freenode was formed in 1988 as the Open Projects Network. Today you might see a lot of people going "freenode" has fallen or "move away from freenode". In fact I am one of those people who will tell you not to use freenode. Why? well early this year Andrew Lee bought freenode inc a holding company that owns all of freenodes infra. For a while the volunteers that made up freenodes staff did their best to keep him from stuff like the password db but sadly they could not stop this.

The fall out has been massive, everyone from [arch linux](https://archlinux.org/news/move-of-official-irc-channels-to-liberachat/) to [ubuntu](https://fridge.ubuntu.com/2021/05/26/announcing-ubuntus-move-to-libera-chat/) have moved all becuase of the new managment. You might say "well null new management isn't a bad thing" and you would be correct. Sadly shortly after people began to move to liberachat a alternative run by former freenode staff Lee began to take over channels that announced their move removing any references to their move to another platform.

This was followed by removing rules that prevented the harassment of individuals belonging to minorities, this move only accelerated the exodus of people from freenode which resulted in Andrew making some very wild accusations claiming that this was a preplanned attack on freenode. Over all most communities have moved or are planing to move from freenode.
