---
title: "Self hosting part 2"
date: 2020-08-29T15:21:57+05:30
series: [movingtomyserver]
tags: [self_hosting, hugo]
draft: true
---

## Background

This is a continuation of the previous post. This will be part 2 of 3 hopefully if I can get my custom tools working. Alot has changed since last post. If you are reading this on the netlify subdomain please head over to <http://nullrequest.com> and continue reading. The linked website is curently running on my own hardware!!!!! Before I continue big thanks to [sesa](https://emalm.com). She really helped my with my nginx configs.

## The three stages?????

Yeah my 3 stages plan went sort of bupkis when I relasied I could only test once I deployed everything but that doesn't mean I haven't worked on the custom tooling at all. Infact if you check out my github you'll find the cloudflare-DDNS repo. This is hopfully the start of a script that should allow use to update the ip without ever having to touch the dashboard on cloudflare. If you have a pfsense box pfsense can actually handle it for you. I may get one in the future but until then its no dice. I'll take about how I deployed everything in this post. 

## Nginx

Nginx is sort of like the holy grail for us right now. If we had embarked on this project before 2004 we would have had to use Apache. While there is nothing inherntly wrong with apache its very very difficult to setup. So then smooth sailing? well no. Nginx on arch is the bare minimum ngnix distribution. It makes things interesting if you like a challange. If not use ubuntu and yeah alot of steps can be skipped. I can't tell you what steps but go through you should be able to figure it out. On arch linux there are 2 versions of nginx. I recomand the mainline version as it will have the latest features. The bellow command should install nginx mainline.

```bash
# pacman -S nginx-mainline
```

Before we start we need to "minify" all html and css so ngnix can serve the files. Hugo saves us alot of time as it has a simple command to create all the html in a minified form. This means there are no spaces in the html.

```bash

$ hugo --gc --minify -b url

```

Replace url with you url. After the command finishes it will create a folder called public. It will have all the html and css needed to deploy the website. I copied all the files to `/var/www/nameofwebsite`.

## configs

ngnix on arch needs some modifications to a few files to make it simpler to deploy websites and services. First we need to edit `ngnix.conf` on other linux distros you might make a config at sites-avalible and symlink it to sites-enabled however arch actually doesn't load the server blocks in sites-enabled. However making arch load it is pretty simple. Open `/etc/nginx/nginx.conf` in a text editor of your choice and add this too the http block

```nginx

include sites-enabled/*;

```

Next up we can create sites-enabled and sites-avalible. You can do this however you want but I am partial to `mkdir`.
