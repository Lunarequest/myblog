---
title: "How to setup Dockerised darkweb website"
date: 2020-07-15T12:59:28+05:30
tag: ['darkweb','docker','python','website']
draft: false
---

## __Discalmer__
I am not resposbile if you break something. Please consult with your laws to see if using Tor is legal in your country. A example where it is not legal is China. In most countries it is legal but again please check you laws. This guide was written for linux but may work on MacOS but will defintely not work on windows without some tweaks.


## Background
After my dockerised IRC project I realised that I wanted to host a website on the dark web. I spent a copule of hours working on this. I hope you guys like this. This tutorial uses [django](https://www.djangoproject.com/) for the website. Below is my file structure if you want to follow.
```
project
├── app   
├── docker-compose.yml
├── Dockerfile
└── tor
    └── Dockerfile

```
## The Website
The website itself can be anything assuming you use django. If you use postgress or any thing else as the database you will need to do some extra configs. This is beyond the scope of this tutorial. The docker container hosting all of this is fairly simple. __You will need to add more steps the more complex your website becomes__.
```Dockerfile
FROM python:3.8
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
RUN pip install django gunicorn
WORKDIR /usr/src/app
COPY ./app/ ./
ENTRYPOINT tail -F /dev/null
```
`gunicorn` is for a later step we can ignore it for now. To test if our website works. We can run the following.
```shell
$ docker build . -t website
$ docker run -d --name website -p 8000:8000 website
$ docker exec -it website python manage.py runserver 0.0.0.0:8000
```
These will build and launch the docker container so we can test it out. Please note if you have a issue with conflicting container names run `docker rm website`. You will be able to navigate to `http://localhost:8000` and see your website running. At this point you can remove the last line ie. `ENTRYPOINT tail -F /dev/null` can be removed.

## The Tor Container
Like the IRC we will be keeping the tor proxy (idk what the correct term is) in a seprate container. We will need to create a new `torrc`. Like before, you can run the following to get the `torrc` file.
```shell
$ sudo cp /etc/tor/torrc ./configs/torrc
```
find the following lines
```
#HiddenServiceDir /var/lib/tor/hidden_service/
#HiddenServicePort 80 127.0.0.1:80
```
Uncomment and change the second line to appeare the same as the one bellow.
```
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 website:8000
```
If you are observent you might notice that the ports are diffrent in the config. This is to ensure that when a person connects using the Tor browser it will automatically connect to the website(using other ports will result in you having to supply a port with the address)

## Docker-Compose
well here we are again. The docker compose file. This is a god send for us as instead of one massive command we have a small one.
```docker-compose.yml
version: '3.7'
services: 
    web:
        container_name: website
        build: .
        command: gunicorn hello_django.wsgi:application --bind 0.0.0.0:8000
        volumes: 
            - ./app/:/usr/src/app/
    
    tor:
        container_name: tor_host
        build: ./tor
        links: 
            - web
        depends_on: 
            - web
        ports: 
            - 9001:9001
            - 9030:9030
```

Remember I said don't worry about gunicorn a while back. Its time to worry about it. If you have used django before you will know it always states when you use `manage.py runserver` do not use this in a production environment. Gunicorn is one of the many option you can use in a situation like this. There are other solutions like uwsgi but they require configs so we are just going to use gunicorn(I am lazy. Sue me if you don't like that (this is a joke)). 

Like before you can run start the entier system with the following commands.
```shell
$ docker-compose up -d
$ docker exec -it tor_host service tor start
$ docker exec -it tor_host cat /var/lib/tor/hidden_service/hostname
```
You will get a .onion link from the last command. __You will not be able to use this in a regular browser__. You will need to use the Tor browser to connect to the website. With some luck you will be able to connect to the website. 

### Final Notes
I encourage to look the [docker docs](https://docs.docker.com/) and the [docker-compose docs](https://docs.docker.com/compose/). Learn how it works and become more confident with using docker. I hope you find this tutorial useful or interseting. Please note just using docker doesn't make your server safe. Please learn how to setup fire walls you can use to lock down your server. 

 — This is nullrquest sign off

