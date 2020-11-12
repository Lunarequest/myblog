---
title: "Raspbian TV"
date: 2020-11-12T17:15:45+05:30
tags: [raspbian_tv]
draft: false
---

A few days ago my parents asked me to give them a cheaper more DIY alternative to a chrome cast/android TV boxes. During my research I remembered reading a article about Plasma big screen TV(PT). The latest endeavor of the KDE foundation which brings a android TV style interface to the Linux desktop. PT also touts features such a using [Mycroft-Ai](https://mycroft.ai/) as as assistant similar to how google assistant is on android TV.

I discovered that no distribution actually had any plans to integrate PT into them. Thus the idea for this distribution was born. The aim is to provide a simple and easy out of the box alternative to android TV for the raspberry pi. 

## Aims
The aims of this project is to produce a android TV like experience for Linux users. This does include getting Mycroft-core,gui and the skill installer packaged as part of the distribution. The main challenge will be to package these as deb files. I also plan to preinstall kodi as an app in raspbian TV.


The .deb file is the package type meant for debian based distributions. My end goal is too have all the packages made for Raspbian TV(The current name of this project) be part of the raspbian repos. I also believe we need to add some form of deb file installer like eddy and the discover store.


The initial release will only support the raspberry pi 4 with the aim of eventually supporting other arm based single boards computers such as the orange pi. If you want to contribute to this project feel free to email me. 

-This is nullrequest signing off 
