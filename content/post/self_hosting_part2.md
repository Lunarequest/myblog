---
title: "Self hosting part 2"
date: 2020-08-29T15:21:57+05:30
series: [movingtomyserver]
tags: [self_hosting, hugo]
draft: false
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

Replace url with you url. After the command finishes it will create a folder called public. It will have all the html and css needed to deploy the website. I copied all the files to `/var/www/nameofwebsite` and changed the ownership of the files using `chown` to the http user.

## configs

ngnix on arch needs some modifications to a few files to make it simpler to deploy websites and services. First we need to edit `ngnix.conf` on other linux distros you might make a config at sites-avalible and symlink it to sites-enabled however arch actually doesn't load the server blocks in sites-enabled. However making arch load it is pretty simple. Open `/etc/nginx/nginx.conf` in a text editor of your choice and add this too the http block

```nginx

include sites-enabled/*;

```

Next up we can create sites-enabled and sites-avalible. You can do this however you want but I am partial to `mkdir`.

```bash
# mkdir /etc/nginx/sites-avalible
# mkdir /etc/nginx/sites-enabled
```

Now we can make our first "server block", A server block esstentially means based on the url or ip address used we can decied what to do with the request. This means you can run multiple websites of the same server with little too no conflicts. To start lets make a site in sites-avalible.

```bash
# touch /etc/nginx/sites-avalible/myblog
```

Before we continue with setting up nginx lets setup cloudflare and get a origin cert. First lets head to <https://www.canyouseeme.org/>.  This service should get you your public ip. __This will change over time__. You may need to update your dns records to reflect your new ip when your ip changes. Get your public IP adress. You need to setup cloudflare with your domain and change TLS to full. Next get a origin cert from cloudflare. You will get a certificate and a key. copy the certifcate text to ` /etc/ssl/youdoaminahere.pem` and the key to  `/etc/ssl/yourdomainhere.key`

Now we need to open the file in a texteditor. I used vim but you can use what texteditor you are comfortable with. Now we can configure everything in ngnix.

```nginx
server {
        listen 443 ssl;
        server_name yourdomainhere;
        ssl_certificate    /etc/ssl/youdomainhere.pem;
        ssl_certificate_key    /etc/ssl/yourdomainhere.key;
        access_log /var/log/nginx/nginx.vhost.access.log;
        error_log /var/log/nginx/nginx.vhost.error.log;

        root /var/www/yourdomainhere;
        index index.html index.htm;

        location / {
                try_files $uri $uri/ =404;
        }
        error_page 404 404.html;
}
```

I know this alot to process but I'll break everything down line by line.
`server {` the first line tell ngnix whats follows is a server block. `listen 443 ssl;` This tells nginx to listen on port 443 and use ssl. The next line tells nginx that this block is realted to your domain and not use it for other ones. The next 2 lines are for https. Nginx needs to know where to get the cert and key.

```nginx
access_log /var/log/nginx/nginx.vhost.access.log;
error_log /var/log/nginx/nginx.vhost.error.log;
```

These lines bassically tell nginx where to wrtie logs too. These can be pretty interesting to go through. __REMEMBER LOGS ARE YOUR BEST FREIND WHEN DEBUGGING__. `root /var/www/yourdomainhere;` this line bassically tells nginx which directory the files are located saving you the hassel of using absolute paths. `index index.html index.htm;` If you have been paying attention you should be able to guess that this line tells nginx to server index.html or index.htm based on what exists when someone acess the raw url.

```nginx
location / {
        try_files $uri $uri/ =404;
        }
```

This section is a bit simple logic that says in simple terms look for a file or path that the url has. Serve the file if you find it. If you don't return a 404 error code. `error_page 404 404.html;` The last line tells nginx that if you have a 404 serve the 404.html document to the user. 

After this you can run the following command to check if there are errors in your code.

```bash
# nginx -t
```

With this we can finish our configs and  start the nginx service. 

```bash
$ systemctl start nginx
```

## Port forwading

This part is basically the last step to deploying our website. This step will change for your router you should be able to setup everything pretty simply. you need to forward 443 on LAN to WAN and with that you should have a working website. You can check if everything works using <https://www.canyouseeme.org/>. You can set the port to 443. 



The next post will be about my work with custom tools that I will be making. If you are still on the old url comments will not work. I will be keeping the website up for a month or two before taking the old url down.

— This is nullrquest signing off 