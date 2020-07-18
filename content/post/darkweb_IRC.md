---
title: "How to setup a darkweb IRC"
date: 2020-07-13T13:00:24+05:30
tag: ['darkweb','docker','IRC']
draft: false
---



## discalmer
I am not resposbile if you break something. Please consult with your laws to see if using Tor is legal in your country. An example where it is not legal is China. In most countries it is legal but again please check you laws.


### Background
Before I get into how to set everything up. I am going to give some background on why I created this guide. Around 3 months ago a discord server I was on wanted to try and create an ultra secure Internet Relay Chat (IRC for short) server. Intially we *tried* to use SSL to secure the server. However, we had a few issues with the certificates which resulted in the project stalling. After some time I relalised we could use [Tor](https://www.torproject.org/) to run the IRC in a more secure manner. We did deploy a Tor based solution but that led to even more problems. Mainly secuity concerns about what would happen if Tor was breached, thus began a 3 week odeasy to Dockerising the setup. Without further ado lets get into the tutorial. This tutorial assumes you use Linux, however this will work with any Opertaing system with some tweaks.

### The IRC server
I orginally intended to compile InspIRCd from source. I found out after a friend pointed out that InspIRCd has a prebuilt [Docker conatiner](https://hub.docker.com/r/inspircd/inspircd-docker/).... So yeah, I wasted a long time on the compile attempt. We are going to setup a quick test. I recomand using this setup to get an inspircd.conf setup.  

```shell
$ docker pull inspircd/inspircd-docker
$ docker run --name inspircd -p 6667:6667 -v /path/to/your/config:/inspircd/conf/ inspircd/inspircd-docker
```
If you want to use my compose file this is the file structure I used.
```
project
├── configs
│   ├── inspircd.conf
│   ├── modules.conf
│   └── motd.txt
├── docker-compose.yml
├── setup.sh
└── tor
    ├── configs
    |       └──torrc
    └── Dockerfile
```
So the last command will be (this is assuming that your working dir is `project`) 
```shell
$ docker run --name inspircd -p 6667:6667 -v ~/project/configs:/inspircd/conf/ inspircd/inspircd-docker
```
### The Tor container
The tor container will, as the name implies, contain tor. This container has one job. Get the IRC online on the Darkweb. We are going to be build a custom container for this using a Dockerfile.
```Dockerfile
FROM ubuntu:focal
#init
RUN apt update && apt upgrade -y
RUN apt install tor -y
#config tor
WORKDIR /home/torrc
COPY ./configs/torrc .
RUN rm /etc/tor/torrc
RUN cp torrc /etc/tor/

ENTRYPOINT  tail -F /dev/null
```
The Docker image is based of Ubuntu 20.04, and uses a custom `torrc` file. We will need to make one of these.
```shell
#if you do not have tor installed. install it before this step. 
#this assumes you are inside the tor directory in a terminal.
$ sudo cp /etc/tor/torrc ./configs/torrc
```
now open up the `torrc` in a a editor of your choice. you may need to change the ownership using `chown`
find the following lines
```
#HiddenServiceDir /var/lib/tor/hidden_service/
#HiddenServicePort 80 127.0.0.1:80
```
Uncomment and change the second line to appeare the same as the one bellow.
```
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 6667 irc:6667
```
The more experinced among you might notice the ip for the service isn't actually a IP but rather a hostname. this will become clearer in the next steps. finnaly build the conatiner with this command
```shell
$ docker build tor -t tor
```

### The test run
If you got this far. well congrates you have achived what took me 2 weeks of trial and error. Now we are going to test everything and hopefully have a running tor based IRC server up and running.
This command launches a conatiner called irc with the base image inspircd/inspircd-docker. Tthis mount the IRC configs at /inspircd/conf/
```shell
$ docker run --name irc -d -v ~/project/configs:/inspircd/conf/ inspircd/inspircd-docker
```
Next run this command. This links the 2 containers with the irc conatiner having the host name irc. this is also why in the torrc we supplied a hostname(which is fixed) rather then a ip(which is not fixed).
```shell
$ docker run -d --name tor --link=irc:irc tor 
```
the next 2 commands start the tor service and give the .onion link of the server
```shell
$ docker exec -it tor service tor start
$ docker exec -it tor cat /var/lib/tor/hidden_service/hostname
```
the second command should spit out your .onion link. to connect to the server follow one of the options from this [guide](https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO/IRC). I recomand hexchat if you are new to the IRC feild. Supply the .onoin link and in a minute you should be conneted to the server.
### Docker-compose
Docker on its own is powerful and in theory you could just continue using the setup we used previously. However if you need to bring it down for maintnace bringing it back up is a __PAIN__ and should never be used in a production evnviorment. Too solve this porblem we shall use a docker-compse.yml(you can also used a .yaml) file. this will make docker compose do the heavy lifting of mounting folders and also linking the 2 containers.

```docker-compose.yml
version: '3.8'

services:
  irc:
    image: inspircd/inspircd-docker
    container_name: irc
    volumes: 
        - type: bind
          source: ./configs
          target: /inspircd/conf/


  app:
    build: ./tor
    container_name: tor
    ports: 
     - 9001:9001
     - 9030:9030
    links: 
     - irc
    depends_on: 
        - irc

volumes: 
  {}
```
This basically runs all the commands except starting tor and giving us the .onion link. This will speed up the enteir process.
to run this use
```shell 
$ docker-compose up -d
```
the `-d` flag tells it to run in detached/headless mode.
finally run these 2 commands to launch the tor proxy.
```shell
$ docker exec -it tor service tor start
$ docker exec -it tor cat /var/lib/tor/hidden_service/hostname
```
### final notes
I encourage to look the [docker docs](https://docs.docker.com/) and the [docker-compose docs](https://docs.docker.com/compose/). Learn how it works and become more confident with using docker. I hope you find this tutorial useful or interseting. Please note just using docker doesn't make your server safe. Please learn how to setup fire walls you can use to lock down your server. 

 — This is nullrquest sign off


