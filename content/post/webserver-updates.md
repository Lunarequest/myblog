---
title: "Webserver Updates"
date: 2022-11-23T06:39:53+05:30
tags: ["Project Iris", "rust", "rocket", "webservers"]
draft: false
---


In my previous post, I wrote about writing a web server for my blog. This is an update on what I've done since then. The answer is surprisingly not much. University exams and similar things have slowed down development to a crawl. If you read my previous blog post. I made a bit of a checklist of things I want to add. What's the status on it?

- [ ] tags(partially implemented)
- [x] working about page
- [x] contact form -Rejected in favor of making people email me. Contact forms get way too much spam

As you can see. I've finished about 66.66666% of the work. Okay. Kinda, I just decided to drop one of the goals, but in fairness, I did partially implement tags. 'Wait null what do you mean you "partially implemented" tags?' you might say. I wrote the SQL for creating a table for the tags and hooking it up to posts. As well as adding a method to save tags. 

A ballpark figure on how far I am into implementing tags is 30~40% optimistically. What's next? After I get around to completing tags on the backend/frontend templates, I will be adding tags support to my migration tool.

I recently discovered [webmentions](https://indieweb.org/Webmention). Webmentions allow other websites to "pingback" when they link your posts/blog. This is very cool. But there's a massive lack of documentation.

I'm hoping I can piece together how webmentions work so I can put together my own implementation, or in the worst case, I'll be using 3rd part services to do it for me. I also need to work towards adding microformats(special classes). This allows better integration with webmentions. 

However, this is a non-blocker. In other words, I will be first finishing tag support deploying and migrating the blog, testing it for some time on [new.nullrequest.com](https://new.nullrequest.com) before I move it to [nullrequest. com](https://nullrequest.com). After this, I'll implement webmentions and microformats.

-- this is nullrequest signing off