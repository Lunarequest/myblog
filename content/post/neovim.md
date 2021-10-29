---
title: "Why you should use Neovim"
date: 2021-10-29T17:34:30+05:30
tags: [neovim, 'messing about']
draft: true
---

Neovim is a fork vim that is just better than vim. In fact, I am writing this post in neovim. Neovim was forked, due to Bram being the sole maintainer of vim. refusing to allow breaking changes in the code. Neovim has been around since 2014 and since then has shown that vim is stuck in the past. 
 
Some of the things that really sealed the deal for using neovim are the built-in LSP integration and treesitter. One of the many things neovim did with the fork was drop a lot of code. This included windows support initially. Currently, neovim is even looking into replacing vim's spellchecker and using
 hunspell instead. 
 
You might say, vim8 has async support. You are right there but, vim was forced to add async support since neovim added it. Vim has been forced to evolve and improve its
elf due to neovim. While for a long time, vim 8 for most users was visibly the same as neovim under the hood things, have been changing. Neovim is at it again changing, the paradigm in the vim world. neovim 5.0 added the ability to replace vim script with Lua. 
 
Now you might ask why Lua? Lua is something people use in Roblox. Not by real coders and, that is where you are wrong. Lua is fast. Node JS is often considered one of the fastest interpreters, is slower. Especially when you use a Jit interpreter as neovim does. The end result is that instead of a init.vim file you can use a init.lua file. Recently I ported my vimscript dependant config to Lua. 
 
I was pleasantly surprised by how fast everything was once I ported it. It was faster than the vimscript version. All vim 8 compatible plugins "just" work with neovim. Most vim8 plugins started out as neovim plugins. The growing number of neovim only plugins forced Bram to release vim 8 with its many async improvements to keep up with neovim. 
 
Porting your vim script config to Lua can be daunting and scary at first. But once you start porting, you will very quickly realize that it is so much better. You can split your config into multiple files. If you can't switch right away to Lua, you can have inline Lua in vimscript with neovim. 
 
LSP is something vim needs to have. LSP or language server protocol was invented by Microsoft for VS code. I can hear you saying, "But null Microsoft is bad" you are right about most things. LSP has changed code editors forever. No longer do you have to write a plugin from scratch for every single code editor. Instead, you create an LSP server with which your plugin just needs to interface with. 
 
Vim can do this. Saying it couldn't would be disingenuous. You need plugins that often slow it down to a crawl. Instead of the many plugins you are often forced to install for each and every language, you can set up neovim's LSP integration to load up the required binary for you giving you the first-class feel with just a few lines of Lua to tell neovim which LSP implementation you prefer for each lang. 
 
The future is now with neovim. Neovim 6 aims to make the LSP config even better and implement more vim-specific APIs in Lua.   Enabling you to reduce the amount of vimscript, you will need to call in Lua. Neovim 0.6 aims to completely implement Treesitter neovim's new highlighting engine and an improved diagnostics API. What are you waiting for? Start hacking neovim! Write your own config!
