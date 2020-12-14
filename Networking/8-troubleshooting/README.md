# Lab - Troubleshooting

## Description

This is a group exercise. Get together and solve the issue.

## Prerequisites

All the labs from Networking

## Objectives

- Teamwork
- Understanding real issues
- Apply learned knowledges

## Software

network tools

## Vagrant

Creates three VMs

`server01`

`client01`

`db01`

password for vagrant user: `vagrant`

## Challenge

### Cannot access the server

Vagrant who sits client01 computer seems to not have access to the server01. Vagrant needs to get access right away to be able to do this work. Help Vagrant to get access to the server01.

### The web server seems to be down

The web server is normally shown on localhost:8080 in the browser. It used to work but now it does no longer.

### The database is exposed - alert! security risk

Our database can be accessed by client01 which means that if any client that lives in the same subnet range can access our db01. **That is a huge security risk!** We want only server01 to access the db01.

Configure that interface eth2 on server01 and reconfigure eth1 on db01 so that they lies within their own private subnet. db01 should no longer be accessable by client01 or any other client. That means that the only way to access db01 is to first ssh from client01 to server01, from server01 ssh to db01.
