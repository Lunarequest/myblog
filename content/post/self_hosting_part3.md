---
title: "Self hosting part 3"
date: 2020-09-31T12:27:34+05:30
series: [movingtomyserver]
tags: [self_hosting, hugo]
draft: false
---

## Introduction

Hello, hello and welcome back to this series This was a long time in the works. A lot has happened. I guess I could say the three step plan is over! but at the same time this is the start of something a lot longer. At some point I might get a twitter to announce down times and such

## Well what happened

To start with I automated the whole process of updating my public IP on cloudflare. This is mainly what delayed me like crazy. I first tried to use a "official" python API wrapper. its community maintained and the docs well to be real are why to complex and aimed at a different audience. Then I found this GitHub repo <https://github.com/yulewang/cloudflare-api-v4-ddns> when I found it. The script only supported ipv4 but it now supports IPv6. I wrote my own script to do the same in python. You can get it from pypi <https://pypi.org/project/simple-cloudflare-ddns/>.

## Auto updating the blog

When I used netlify the blog would auto update and publish the blog. I wanted to recreate this in my setup. I began researching what I could do. I made a flask server that gets a key and runs a bunch of commands when it gets a post request.

```python
from flask import Flask, request
import os
import threading

app = Flask(__name__)

def update_static():
source = "/home/nullrequest/myblog"
os.chdir(source)
os.system("git pull")
os.system("hugo --gc --minify -b https://nullrequest.com/")
os.system("echo 'finshed running thread'")

@app.route("/", methods=["GET", "POST"])
def update():
if request.method == "GET":
return "Your not supposed to be here"
elif request.method == "POST":
elif request.method == "POST":
key = request.form["key"]
if key == os.environ.get("key"):
update_thread = threading.Thread(target=update_static)
update_thread.start()
return "Hello Octocat"
```

As you can see its pretty sleek. Using a web hook you can get GitHub to send you a update post request with any value to your server. Its pretty effective at replicating what happened in netlify setup except there they used git hubs API. Honestly if I wasn't so confused by docs I would have used the API.

With that I end the dev part of this series. I may add more stuff as time goes on. One thing for sure I am going to be writing is about why you should/shouldn't try this. For some people its really simpler to use a hosting provider due to the benefits they have. 

— This is questioner signing off
