---
title: "How to make a hugo website"
date: 2020-07-18T12:12:08+05:30
tags: ['Hugo']
draft: true
---
## Background
The more astute of you may have noticed that this blog is a static content site and you would be correct. I wanted to make a blog but didn't want to work on the backend because that takes time and I wanted to blog ASAP. I found out about 2 solutions jekkyl and hugo.I chose Hugo over jekkyl due to its speed and abilty to scale up. Hugo has a bit of leanring curve so don't give up.

## The setup
At this point you want to install hugo. I recomand getting the it from the [offical repo](https://github.com/gohugoio/hugo/releases). You can use the version from your distros repos but some themes maybe incompatible.

## Creating and running A hugo website 
creating a website is very simple with hugo. 
```shell
$ hugo new site the_name_of_your_project
```
After creating this site you will need a theme. you can change your directory to the newly created site. the following steps will depened on your theme.
```shell
$  git submodule add https://github.com/matsuyoshi30/harbor.git themes/harbor
```
with that you now have a theme. now we need to edit the `config.toml/.json/.yaml` file.the file extenstion and sytanx will be diffrent but hugo supports all of exetsions mentioned. I used the toml file but you can use whatever you prefer

