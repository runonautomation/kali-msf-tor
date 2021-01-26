## Introduction
This repository is an example of docker-compose stack
for msf+kali workstation with TOR

Based on:
dperson/torproxy

## Requirements
- docker-compose
- docker
- linux (tested on Ubuntu/MacOS docker as well)

## Usage
- Build the image of Kali, edit Dockerfile for getting custom packages
```
docker-compose build
```
- Start the stack
```
docker-compose up
```
- Edit the route_tor.sh to depict your internal network

- Go to kali container
```
docker exec -it kali bash
```
- !!! Check your IP, it should be inside tor network
```
curl ifconfig.me/ip
```
