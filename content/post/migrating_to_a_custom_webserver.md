---
title: "Migrating to a custom blogging backend"
date: 2022-10-17T20:23:22+05:30
tags: ["Project Iris", "rust", "rocket", "webservers"]
draft: false
---

I've not posted in a long time. I promise I'm trying to write these more often. In fact, I've tried writing a bunch of blog posts on everything from running a custom clang-built kernel to my phone setup with Lineage os and MicroG. However, a simple project I've dubbed "project Iris", has been consuming most of my time. Over the past few months, I've been working on writing a blogging framework/backend from scratch. 

Project Iris is an all-in-one web blogging application that supports all my needs such as an inbuilt Markdown editor support or an API to add and remove images. Overall it has come very close to replacing this blog however, I'm not ready to replace my current blog with Iris.

Here's a short list of things I have here that I need to implement.

- [ ] tags
- [ ] working about page(I know I need to add it, but I keep forgetting :D )
- [ ] contact form 

Yup. I've implemented most of what I have on this blog. I'm close to being able to replace it but not quite there. At this point, I do need to start testing it and making it blow up. The more issues I find while deploying it in a development env is more bugs fixed before production. 

I'm using [rocket](https://rocket.rs) to write the webserver as I'm not a fan of Axum, or Actix-web the two other popular web server frameworks in the rust ecosystem. Rocket feels in between Django and Flask in terms of boilerplate and helper/ORMs libs. I find this to be refreshing and the perfect balance for me. In terms of database, I'm just using a bog standard Postgresql database interfaced with diesel(the best SQL ORM in the rust ecosystem IMO)

I also need to migrate 28 blog posts(including WIPs). There is no way I can migrate all of them by hand. There are also a few minor things I would like to add that I don't have here, namely automated moving from draft -> published based on time/dates.

One feature I would like to add is automated publishing/announcing to various social media such as Instagram. This feature was heavily inspired by Xe Iaso's blog([xeiaso.net](https://xeisao.net)), which also inspired most of this project. While I will probably not micro-optimize to the point this loads faster than a static site, I aim to make it "fast as fuck".

-- this is nullrequest writing again after a really long time


