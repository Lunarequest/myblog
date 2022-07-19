---
title: "Clang built kernels"
date: 2022-07-05T21:23:34+05:30
tags: [clang, linux]
draft: true
---
Clang is a C-compiler that aims to be abi compatible with the GNU project C and C++ compiler(GCC). It uses LLVM as a backend and offers features like shodow Control flow intergitry, which as of writing is not offered by GCC.

I was quite intreged by ThinLTO and clang built kernels in general, and since OpenMandriva began to offer a clang built linux kernel along side its own vanilla kernel built with GCC. Clang offers a plathora of benifits over GCC including but not limited to, better error messages, better sanitization, better profiling and even better plugins. All of this is just the icing on the cake, clang turns out to produce faster binaries when compared to GCC. 

Becuase of the above I've been wanting to try out a Clang built kernel for a while now and recently gave in to temptation. Building a clang built kernel is actually suprisingly simple. You can take the quick and dirty route of setting `CC=clang CXX=clang++ LD=ld.lld` when building the kernel which will get you started with a basic clang build kernel.

But if you want LTO/ThinLTO you need to a little more work. First we need llvm's versions of the binutils. On most linux distros this is achived by installing the `llvm` package along side clang. Once this is done, we can build a gnu less kernel. It is achived fairly simply by add `LLVM=1 LLVM_IAS=1`. LLVM=1 tells the linux buildsystem that you want to use llvm and its utilites and LLVM_IAS=1 tells the kernel to use the intergrated clang assembler.

After this its of to the races. I did this but instead of making a hand made custom kernel I simply used arch's PKGBUILD for the linux kernel with some minor patches. The end result is a slightly faster and bigger kernel. I've been messing with kernel options for a bit now, and so far have got the beloved penguins back into the boot output and hopfully soon SeLinux working on my arch install.