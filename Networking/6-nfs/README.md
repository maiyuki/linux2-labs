# Lab - NFS

## Description

A network file system enables local users to access remote data and files in the same way they are accessed locally.

## Prerequisites

none

## Objectives

- Setup a NFS server on `server01`
- Manual mount file system to `client01`
- Auto mount file system to `client01`

## Software

nfs

## Vagrant

Network: `172.22.100.0/24`

Creates two VMs
`server01 172.22.100.10`
`client01 172.22.100.20`

## TODO

### Setup NFS Server

- Download and cache in binary format metadata for all known repos

```bash
dnf makecache
```

- Install nfs-utils package

```bash
dnf install nfs-utils
```

- Start nfs server service

```bash
systemctl start nfs-server.service
```

- Enable it to automatically start at system boot

```bash
systemctl enable nfs-server.service
```

- Verify its status

```bash
systemctl status nfs-server.service
```

## Extra

- Setup client02 and mount file system
- Create a file that only you can edit. Verify that client01 cannot edit client02's files

## Link

-
