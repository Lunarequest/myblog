---
title: "Arch install automation"
date: 2020-08-06T09:12:49+05:30
tags: [arch, automation, ansible]
draft: true
---
## background
I have a OEM desktop that I use as a headless(without a display) server. I found that I nuke this server very often when I mess something up and have to reinstall. With my recent move switching to Arch as the os running on it. Reinstalling became a hassel. This post will take a diffrent approch. Rather then give instructions on how to make/build everything. I will talk about what I did and why I did that.

## The plan
First I need to make a custom iso. This iso had to boot regularly some how tell my laptop its ip and finally get sshed into by ansible which will allow ansible to install arch for me. I broke the problem down into stages
stage 1. get the ip
stage 2. auth in ssh without password
stage 3. install arch

## Stage 1
Stage 1 was the simplest part of the project. I started with finding out how I could get my IP. For this section I exmployed Python. I used python due to my fimilarity with it. To get the IP adress I used `socket`. This is the function I used to get my IP.

```python
def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    ip = s.getsockname()[0]
    s.close()
    return ip
```
Its a nifty little piece of code that pings googles DNS server and then gets the current ip from the socket and closes the socket. The next part stumped me for a while. How would I send the ip to my laptop. After about 5 minutes of thinking I though maybe I could run a Django webserver. After 5 more minutes of thinking I came to the conclusion  that while the idea was right using a webserver would be good django was overkill. Enter our next contender flask. Flask is the arch of the python web dev world. While Django neatly handles 99% of the work flask is the opposite. You need to configure and handle everything(well almost everything).

I Would like to show my flask code but its nothing special. It recives the the request (a get in this case) and prints the ip which is sent as a parameter of the get request. To send the get request I used the `requests` python module. the function for this was suprisngly simple to use.

```python
def send_ip(ip):
    URL = "http://127.0.0.1:5000"
    PARAMS = {"ip": ip}
    r = requests.get(url=URL, data=PARAMS)
    print(r)
    print(r.text)
```
currently the url is set to localhost but you can change it to the ip of your system. This is where my first road block was hit. I orginally planed to use systemd to load up and run the program for me. Sadly the systems ip isn't set until DHCP requests are made bu `dhcpcd`. So I moved to plan b using the zshrc. At this point I spent 2 days lerning, making and testing a custom arch iso. At this point I realised that I could tackel stage 2 with the iso.

## Stage 2
A password isn't the only way to login to a remote host using ssh. The alterntive more secure method is a SSH key. A key pair(one private and one public) can be made fairly quickly. I recomand follow the guide by github on how to set it up. So I add a section in the iso to copy my key into the iso. allowing me to login and execute commands as root without ever inputing the password.


## Stage 3
This was what held me back for a short while(okay it wasn't a short while it was a month). At one point I thought of using `Chef` instead of `ansible`. While I did start porting to chef. It quickly ended becuase chef just doesn't have modules like asibles parted module. The install is pretty standard except instead of using `arch-chroot /mnt` you have to run command outside and when it needs to be run inside a chroot you use `arch-chroot /mnt command`. There was 2 problems that really stumpped me when I ran into them. The first one was the grub install. I used grub over systemd because the server only had bios support.

I discorved you dont give `grub-install` a partion but rather the enteir disk. After this the install was pretty smooth sailing. Until I hit the user creation section. Currently I haven't figured out how to fix the issue but the one solution I am trying to get working is `chpasswd`. If someone figures out how it works please do hit me up. I really would like to solve it. I  will be uploading everything to my github so anyone can use it. One last thing. If you want to install arch do it yourself. Do your research and it will pay off. Installing arch teachs you alot about how linux works. Also don't use arch as your first Linux distro use linux mint or pop os

- This is nullrequest signing off